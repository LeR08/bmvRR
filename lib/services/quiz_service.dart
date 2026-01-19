import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../config/firebase_config.dart';
import '../models/quiz.dart';
import '../models/quiz_result.dart';
import '../models/quiz_series.dart';
import '../models/user.dart';

class QuizService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Charger les quiz depuis les assets (JSON local)
  Future<List<Quiz>> loadQuizzesFromAssets() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/quiz/quizzes.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Quiz.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading quizzes from assets: $e');
      return [];
    }
  }

  // Récupérer tous les quiz (depuis Firestore ou cache local)
  Future<List<Quiz>> getAllQuizzes() async {
    try {
      final querySnapshot = await _firestore
          .collection(FirestoreCollections.quizzes)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Quiz.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error getting quizzes from Firestore: $e');
      // Fallback sur les assets
      return await loadQuizzesFromAssets();
    }
  }

  // Récupérer un quiz spécifique
  Future<Quiz?> getQuiz(String quizId) async {
    try {
      final doc = await _firestore
          .collection(FirestoreCollections.quizzes)
          .doc(quizId)
          .get();

      if (doc.exists && doc.data() != null) {
        return Quiz.fromJson(doc.data()!);
      }
    } catch (e) {
      debugPrint('Error getting quiz: $e');
    }
    return null;
  }

  // Récupérer les quiz filtrés par type
  Future<List<Quiz>> getQuizzesByType(QuizType type) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirestoreCollections.quizzes)
          .where('type', isEqualTo: type.name)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Quiz.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error getting quizzes by type: $e');
      return [];
    }
  }

  // Récupérer les quiz accessibles pour un utilisateur
  Future<List<Quiz>> getAccessibleQuizzes(AppUser user) async {
    final allQuizzes = await getAllQuizzes();

    return allQuizzes.where((quiz) {
      if (!quiz.isPremium) return true; // Quiz gratuits

      if (quiz.requiredTier == null) return true;

      switch (quiz.requiredTier) {
        case 'solo':
          return user.canAccessSoloContent;
        case 'couple':
          return user.canAccessCoupleContent;
        case 'elite':
          return user.canAccessEliteContent;
        default:
          return false;
      }
    }).toList();
  }

  // Sauvegarder un résultat de quiz
  Future<void> saveQuizResult(QuizResult result) async {
    try {
      await _firestore
          .collection(FirestoreCollections.quizResults)
          .doc(result.id)
          .set(result.toJson());
    } catch (e) {
      debugPrint('Error saving quiz result: $e');
      rethrow;
    }
  }

  // Récupérer les résultats d'un utilisateur
  Future<List<QuizResult>> getUserResults(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirestoreCollections.quizResults)
          .where('userId', isEqualTo: userId)
          .orderBy('completedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => QuizResult.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error getting user results: $e');
      return [];
    }
  }

  // Récupérer les résultats d'un quiz spécifique pour un utilisateur
  Future<List<QuizResult>> getQuizResultsForUser(String userId, String quizId) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirestoreCollections.quizResults)
          .where('userId', isEqualTo: userId)
          .where('quizId', isEqualTo: quizId)
          .orderBy('completedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => QuizResult.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error getting quiz results for user: $e');
      return [];
    }
  }

  // Comparer les résultats de deux partenaires
  Future<QuizComparison?> compareResults(
    String userId,
    String partnerId,
    String quizId,
  ) async {
    try {
      final userResults = await getQuizResultsForUser(userId, quizId);
      final partnerResults = await getQuizResultsForUser(partnerId, quizId);

      if (userResults.isEmpty || partnerResults.isEmpty) {
        return null;
      }

      final userResult = userResults.first;
      final partnerResult = partnerResults.first;

      // Calculer les comparaisons
      final comparisons = <String, ComparisonItem>{};
      int similarCount = 0;

      final quiz = await getQuiz(quizId);
      if (quiz == null) return null;

      for (final question in quiz.questions) {
        final userAnswer = userResult.answers[question.id];
        final partnerAnswer = partnerResult.answers[question.id];

        if (userAnswer != null && partnerAnswer != null) {
          final isSimilar = _areAnswersSimilar(userAnswer, partnerAnswer);
          if (isSimilar) similarCount++;

          comparisons[question.id] = ComparisonItem(
            questionId: question.id,
            questionText: question.text,
            user1Answer: userAnswer,
            user2Answer: partnerAnswer,
            isSimilar: isSimilar,
            insight: _generateInsight(question, userAnswer, partnerAnswer),
          );
        }
      }

      final similarityScore = (similarCount / quiz.questions.length) * 100;
      final discussionQuestions = _generateDiscussionQuestions(quiz, comparisons);

      return QuizComparison(
        user1Result: userResult,
        user2Result: partnerResult,
        comparisons: comparisons,
        similarityScore: similarityScore,
        discussionQuestions: discussionQuestions,
      );
    } catch (e) {
      debugPrint('Error comparing results: $e');
      return null;
    }
  }

  bool _areAnswersSimilar(UserAnswer answer1, UserAnswer answer2) {
    // Considère similaire si les réponses sont identiques
    // ou si les scores sont proches (différence <= 1)
    if (answer1.selectedAnswerIds.first == answer2.selectedAnswerIds.first) {
      return true;
    }
    return (answer1.score - answer2.score).abs() <= 1;
  }

  String? _generateInsight(
    question,
    UserAnswer userAnswer,
    UserAnswer partnerAnswer,
  ) {
    if (_areAnswersSimilar(userAnswer, partnerAnswer)) {
      return 'Vous êtes sur la même longueur d\'onde';
    } else {
      return 'Vos perspectives diffèrent, c\'est une opportunité d\'échange';
    }
  }

  List<String> _generateDiscussionQuestions(
    Quiz quiz,
    Map<String, ComparisonItem> comparisons,
  ) {
    final questions = <String>[];

    // Trouver les plus grandes différences
    final differences = comparisons.values
        .where((c) => !c.isSimilar)
        .toList()
      ..sort((a, b) => (b.user1Answer.score - b.user2Answer.score).abs()
          .compareTo((a.user1Answer.score - a.user2Answer.score).abs()));

    if (differences.isNotEmpty) {
      questions.add('Pourquoi avez-vous des points de vue différents sur "${differences.first.questionText}" ?');
    }

    questions.add('Qu\'avez-vous appris de nouveau sur votre partenaire ?');
    questions.add('Y a-t-il des sujets que vous aimeriez approfondir ensemble ?');

    return questions;
  }

  // Récupérer toutes les séries
  Future<List<QuizSeries>> getAllSeries() async {
    try {
      final querySnapshot = await _firestore
          .collection(FirestoreCollections.quizSeries)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => QuizSeries.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error getting series: $e');
      return [];
    }
  }

  // Récupérer une série spécifique
  Future<QuizSeries?> getSeries(String seriesId) async {
    try {
      final doc = await _firestore
          .collection(FirestoreCollections.quizSeries)
          .doc(seriesId)
          .get();

      if (doc.exists && doc.data() != null) {
        return QuizSeries.fromJson(doc.data()!);
      }
    } catch (e) {
      debugPrint('Error getting series: $e');
    }
    return null;
  }

  // Récupérer la progression d'une série pour un utilisateur
  Future<SeriesProgress?> getSeriesProgress(String userId, String seriesId) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirestoreCollections.seriesProgress)
          .where('userId', isEqualTo: userId)
          .where('seriesId', isEqualTo: seriesId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return SeriesProgress.fromJson(querySnapshot.docs.first.data());
      }
    } catch (e) {
      debugPrint('Error getting series progress: $e');
    }
    return null;
  }

  // Mettre à jour la progression d'une série
  Future<void> updateSeriesProgress(SeriesProgress progress) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirestoreCollections.seriesProgress)
          .where('userId', isEqualTo: progress.userId)
          .where('seriesId', isEqualTo: progress.seriesId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update(progress.toJson());
      } else {
        await _firestore
            .collection(FirestoreCollections.seriesProgress)
            .add(progress.toJson());
      }
    } catch (e) {
      debugPrint('Error updating series progress: $e');
      rethrow;
    }
  }
}
