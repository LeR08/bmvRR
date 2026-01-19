import 'question.dart';

class QuizResult {
  final String id;
  final String userId;
  final String quizId;
  final Map<String, UserAnswer> answers; // questionId -> UserAnswer
  final int totalScore;
  final DateTime completedAt;
  final int timeSpentSeconds;
  final String? partnerId; // Si joué en couple
  final bool isSharedWithPartner;

  QuizResult({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.answers,
    required this.totalScore,
    required this.completedAt,
    required this.timeSpentSeconds,
    this.partnerId,
    this.isSharedWithPartner = false,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    final answersMap = json['answers'] as Map<String, dynamic>;
    final answers = answersMap.map(
      (key, value) => MapEntry(
        key,
        UserAnswer.fromJson(value as Map<String, dynamic>),
      ),
    );

    return QuizResult(
      id: json['id'] as String,
      userId: json['userId'] as String,
      quizId: json['quizId'] as String,
      answers: answers,
      totalScore: json['totalScore'] as int,
      completedAt: DateTime.parse(json['completedAt'] as String),
      timeSpentSeconds: json['timeSpentSeconds'] as int,
      partnerId: json['partnerId'] as String?,
      isSharedWithPartner: json['isSharedWithPartner'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'quizId': quizId,
      'answers': answers.map((key, value) => MapEntry(key, value.toJson())),
      'totalScore': totalScore,
      'completedAt': completedAt.toIso8601String(),
      'timeSpentSeconds': timeSpentSeconds,
      'partnerId': partnerId,
      'isSharedWithPartner': isSharedWithPartner,
    };
  }
}

class UserAnswer {
  final String questionId;
  final List<String> selectedAnswerIds; // Peut être multiple pour multiSelect
  final int score;
  final DateTime answeredAt;

  UserAnswer({
    required this.questionId,
    required this.selectedAnswerIds,
    required this.score,
    required this.answeredAt,
  });

  factory UserAnswer.fromJson(Map<String, dynamic> json) {
    return UserAnswer(
      questionId: json['questionId'] as String,
      selectedAnswerIds: List<String>.from(json['selectedAnswerIds'] ?? []),
      score: json['score'] as int,
      answeredAt: DateTime.parse(json['answeredAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'selectedAnswerIds': selectedAnswerIds,
      'score': score,
      'answeredAt': answeredAt.toIso8601String(),
    };
  }
}

// Comparaison entre deux résultats (couple)
class QuizComparison {
  final QuizResult user1Result;
  final QuizResult user2Result;
  final Map<String, ComparisonItem> comparisons;
  final double similarityScore; // 0-100%
  final List<String> discussionQuestions;

  QuizComparison({
    required this.user1Result,
    required this.user2Result,
    required this.comparisons,
    required this.similarityScore,
    required this.discussionQuestions,
  });
}

class ComparisonItem {
  final String questionId;
  final String questionText;
  final UserAnswer user1Answer;
  final UserAnswer user2Answer;
  final bool isSimilar;
  final String? insight; // Commentaire sur la différence

  ComparisonItem({
    required this.questionId,
    required this.questionText,
    required this.user1Answer,
    required this.user2Answer,
    required this.isSimilar,
    this.insight,
  });
}
