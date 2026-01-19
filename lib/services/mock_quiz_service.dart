import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/quiz.dart';
import '../models/quiz_result.dart';
import '../models/quiz_series.dart';
import '../models/user.dart';

/// Service de quiz mocké pour tester l'app sans Firebase
class MockQuizService {
  List<Quiz>? _cachedQuizzes;
  final List<QuizResult> _mockResults = [];
  final List<QuizSeries> _mockSeries = [];

  // Charger les quiz depuis les assets
  Future<List<Quiz>> getAllQuizzes() async {
    if (_cachedQuizzes != null) {
      return _cachedQuizzes!;
    }

    try {
      final String jsonString = await rootBundle.loadString('assets/quiz/quizzes.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      _cachedQuizzes = jsonList.map((json) => Quiz.fromJson(json)).toList();
      debugPrint('🎭 DEMO MODE: Loaded ${_cachedQuizzes!.length} quizzes from assets');
      return _cachedQuizzes!;
    } catch (e) {
      debugPrint('🎭 DEMO MODE: Error loading quizzes: $e');
      return [];
    }
  }

  Future<Quiz?> getQuiz(String quizId) async {
    final quizzes = await getAllQuizzes();
    try {
      return quizzes.firstWhere((q) => q.id == quizId);
    } catch (e) {
      return null;
    }
  }

  Future<List<Quiz>> getQuizzesByType(QuizType type) async {
    final quizzes = await getAllQuizzes();
    return quizzes.where((q) => q.type == type).toList();
  }

  Future<List<Quiz>> getAccessibleQuizzes(AppUser user) async {
    final allQuizzes = await getAllQuizzes();

    // En mode démo, tous les quiz sont accessibles
    debugPrint('🎭 DEMO MODE: All ${allQuizzes.length} quizzes are accessible');
    return allQuizzes;
  }

  Future<void> saveQuizResult(QuizResult result) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockResults.add(result);
    debugPrint('🎭 DEMO MODE: Quiz result saved (total: ${_mockResults.length})');
  }

  Future<List<QuizResult>> getUserResults(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // Retourner les résultats mockés + quelques résultats de démo
    if (_mockResults.isEmpty) {
      _generateDemoResults(userId);
    }

    return List.from(_mockResults);
  }

  Future<List<QuizResult>> getQuizResultsForUser(String userId, String quizId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockResults.where((r) => r.userId == userId && r.quizId == quizId).toList();
  }

  Future<QuizComparison?> compareResults(
    String userId,
    String partnerId,
    String quizId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('🎭 DEMO MODE: Comparison feature not available in demo mode');
    return null;
  }

  Future<List<QuizSeries>> getAllSeries() async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (_mockSeries.isEmpty) {
      _generateDemoSeries();
    }

    return List.from(_mockSeries);
  }

  Future<QuizSeries?> getSeries(String seriesId) async {
    final series = await getAllSeries();
    try {
      return series.firstWhere((s) => s.id == seriesId);
    } catch (e) {
      return null;
    }
  }

  Future<SeriesProgress?> getSeriesProgress(String userId, String seriesId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Retourner une progression de démo
    return SeriesProgress(
      userId: userId,
      seriesId: seriesId,
      completedQuizIds: [],
      currentQuizIndex: 0,
      startedAt: DateTime.now(),
    );
  }

  Future<void> updateSeriesProgress(SeriesProgress progress) async {
    await Future.delayed(const Duration(milliseconds: 200));
    debugPrint('🎭 DEMO MODE: Series progress updated');
  }

  void _generateDemoResults(String userId) {
    final now = DateTime.now();

    // Générer quelques résultats de démo
    _mockResults.addAll([
      QuizResult(
        id: 'demo_result_1',
        userId: userId,
        quizId: 'quiz_001',
        answers: {},
        totalScore: 18,
        completedAt: now.subtract(const Duration(days: 2)),
        timeSpentSeconds: 420,
      ),
      QuizResult(
        id: 'demo_result_2',
        userId: userId,
        quizId: 'quiz_002',
        answers: {},
        totalScore: 22,
        completedAt: now.subtract(const Duration(days: 5)),
        timeSpentSeconds: 360,
      ),
      QuizResult(
        id: 'demo_result_3',
        userId: userId,
        quizId: 'quiz_005',
        answers: {},
        totalScore: 15,
        completedAt: now.subtract(const Duration(days: 7)),
        timeSpentSeconds: 480,
      ),
    ]);
  }

  void _generateDemoSeries() {
    _mockSeries.addAll([
      QuizSeries(
        id: 'series_001',
        title: 'Mieux se comprendre à distance',
        description: 'Un parcours pour renforcer votre connexion émotionnelle',
        quizIds: ['quiz_001', 'quiz_003'],
        isPremium: false,
        estimatedTotalMinutes: 25,
        category: 'communication',
      ),
      QuizSeries(
        id: 'series_002',
        title: 'Construire un futur commun',
        description: 'Explorez vos projets et alignez vos visions',
        quizIds: ['quiz_004'],
        isPremium: true,
        requiredTier: 'couple',
        estimatedTotalMinutes: 15,
        category: 'future',
      ),
    ]);
  }
}
