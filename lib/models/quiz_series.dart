// Parcours relationnel (série de quiz)
class QuizSeries {
  final String id;
  final String title;
  final String description;
  final List<String> quizIds; // IDs des quiz dans l'ordre
  final String? imageUrl;
  final bool isPremium;
  final String? requiredTier;
  final int estimatedTotalMinutes;
  final String category; // "communication", "trust", "future", etc.
  final DateTime createdAt;

  QuizSeries({
    required this.id,
    required this.title,
    required this.description,
    required this.quizIds,
    this.imageUrl,
    this.isPremium = false,
    this.requiredTier,
    required this.estimatedTotalMinutes,
    required this.category,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory QuizSeries.fromJson(Map<String, dynamic> json) {
    return QuizSeries(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      quizIds: List<String>.from(json['quizIds'] ?? []),
      imageUrl: json['imageUrl'] as String?,
      isPremium: json['isPremium'] as bool? ?? false,
      requiredTier: json['requiredTier'] as String?,
      estimatedTotalMinutes: json['estimatedTotalMinutes'] as int,
      category: json['category'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'quizIds': quizIds,
      'imageUrl': imageUrl,
      'isPremium': isPremium,
      'requiredTier': requiredTier,
      'estimatedTotalMinutes': estimatedTotalMinutes,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

// Progression dans une série
class SeriesProgress {
  final String userId;
  final String seriesId;
  final List<String> completedQuizIds;
  final int currentQuizIndex;
  final DateTime startedAt;
  final DateTime? completedAt;

  SeriesProgress({
    required this.userId,
    required this.seriesId,
    required this.completedQuizIds,
    required this.currentQuizIndex,
    required this.startedAt,
    this.completedAt,
  });

  bool get isCompleted => completedAt != null;

  double getProgress(int totalQuizzes) {
    if (totalQuizzes == 0) return 0.0;
    return completedQuizIds.length / totalQuizzes;
  }

  factory SeriesProgress.fromJson(Map<String, dynamic> json) {
    return SeriesProgress(
      userId: json['userId'] as String,
      seriesId: json['seriesId'] as String,
      completedQuizIds: List<String>.from(json['completedQuizIds'] ?? []),
      currentQuizIndex: json['currentQuizIndex'] as int,
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'seriesId': seriesId,
      'completedQuizIds': completedQuizIds,
      'currentQuizIndex': currentQuizIndex,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}
