import 'package:flutter/foundation.dart';
import '../models/quiz.dart';
import '../models/quiz_result.dart';
import '../models/quiz_series.dart';
import '../models/user.dart';
import '../services/quiz_service.dart';
import '../services/user_service.dart';

class QuizProvider with ChangeNotifier {
  final QuizService _quizService = QuizService();
  final UserService _userService = UserService();

  List<Quiz> _allQuizzes = [];
  List<Quiz> _accessibleQuizzes = [];
  List<QuizSeries> _allSeries = [];
  List<QuizResult> _userResults = [];
  Quiz? _currentQuiz;
  Map<String, dynamic> _currentAnswers = {};
  int _currentQuestionIndex = 0;
  DateTime? _quizStartTime;
  bool _isLoading = false;
  String? _errorMessage;

  List<Quiz> get allQuizzes => _allQuizzes;
  List<Quiz> get accessibleQuizzes => _accessibleQuizzes;
  List<QuizSeries> get allSeries => _allSeries;
  List<QuizResult> get userResults => _userResults;
  Quiz? get currentQuiz => _currentQuiz;
  Map<String, dynamic> get currentAnswers => _currentAnswers;
  int get currentQuestionIndex => _currentQuestionIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get progress {
    if (_currentQuiz == null) return 0.0;
    return (_currentQuestionIndex + 1) / _currentQuiz!.questions.length;
  }

  Future<void> loadQuizzes(AppUser user) async {
    _isLoading = true;
    notifyListeners();

    try {
      _allQuizzes = await _quizService.getAllQuizzes();
      _accessibleQuizzes = await _quizService.getAccessibleQuizzes(user);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erreur lors du chargement des quiz';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSeries() async {
    try {
      _allSeries = await _quizService.getAllSeries();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading series: $e');
    }
  }

  Future<void> loadUserResults(String userId) async {
    try {
      _userResults = await _quizService.getUserResults(userId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user results: $e');
    }
  }

  void startQuiz(Quiz quiz) {
    _currentQuiz = quiz;
    _currentAnswers = {};
    _currentQuestionIndex = 0;
    _quizStartTime = DateTime.now();
    notifyListeners();
  }

  void answerQuestion(String questionId, List<String> answerIds, int score) {
    _currentAnswers[questionId] = UserAnswer(
      questionId: questionId,
      selectedAnswerIds: answerIds,
      score: score,
      answeredAt: DateTime.now(),
    );
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentQuiz != null && _currentQuestionIndex < _currentQuiz!.questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  bool canGoToNextQuestion() {
    if (_currentQuiz == null) return false;
    final currentQuestion = _currentQuiz!.questions[_currentQuestionIndex];
    return _currentAnswers.containsKey(currentQuestion.id);
  }

  Future<QuizResult?> finishQuiz(String userId, {String? partnerId}) async {
    if (_currentQuiz == null || _quizStartTime == null) return null;

    try {
      final timeSpent = DateTime.now().difference(_quizStartTime!).inSeconds;
      final totalScore = _currentAnswers.values
          .fold<int>(0, (sum, answer) => sum + answer.score);

      final result = QuizResult(
        id: '${userId}_${_currentQuiz!.id}_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        quizId: _currentQuiz!.id,
        answers: Map<String, UserAnswer>.from(_currentAnswers),
        totalScore: totalScore,
        completedAt: DateTime.now(),
        timeSpentSeconds: timeSpent,
        partnerId: partnerId,
        isSharedWithPartner: partnerId != null,
      );

      await _quizService.saveQuizResult(result);

      // Mettre à jour les statistiques utilisateur
      final timeSpentMinutes = (timeSpent / 60).ceil();
      await _userService.incrementQuizCompleted(userId, timeSpentMinutes);

      // Réinitialiser l'état
      _currentQuiz = null;
      _currentAnswers = {};
      _currentQuestionIndex = 0;
      _quizStartTime = null;

      notifyListeners();
      return result;
    } catch (e) {
      debugPrint('Error finishing quiz: $e');
      _errorMessage = 'Erreur lors de la sauvegarde du quiz';
      notifyListeners();
      return null;
    }
  }

  void cancelQuiz() {
    _currentQuiz = null;
    _currentAnswers = {};
    _currentQuestionIndex = 0;
    _quizStartTime = null;
    notifyListeners();
  }

  List<Quiz> getQuizzesByType(QuizType type) {
    return _accessibleQuizzes.where((quiz) => quiz.type == type).toList();
  }

  List<Quiz> getFeaturedQuizzes() {
    // Retourner les quiz les plus récents et populaires
    return _accessibleQuizzes.take(5).toList();
  }

  Future<QuizComparison?> compareWithPartner(
    String userId,
    String partnerId,
    String quizId,
  ) async {
    try {
      return await _quizService.compareResults(userId, partnerId, quizId);
    } catch (e) {
      debugPrint('Error comparing results: $e');
      return null;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
