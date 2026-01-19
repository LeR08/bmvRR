import 'question.dart';

enum QuizType {
  fun, // Quiz vague, ludique
  precise, // Quiz précis sur un thème
  personality, // Test de personnalité
  astrology, // Astrologie symbolique
}

enum QuizMode {
  solo, // Jouable seul
  couple, // À deux (synchronisé ou asynchrone)
  both, // Les deux modes possibles
}

enum QuizDifficulty {
  easy,
  medium,
  hard,
}

class Quiz {
  final String id;
  final String title;
  final String description;
  final QuizType type;
  final QuizMode mode;
  final QuizDifficulty difficulty;
  final List<Question> questions;
  final String? imageUrl;
  final List<String> tags;
  final bool isPremium; // Nécessite un abonnement
  final String? requiredTier; // 'solo', 'couple', 'elite', null si gratuit
  final int estimatedMinutes;
  final String? seriesId; // ID de la série si fait partie d'un parcours
  final int? orderInSeries; // Ordre dans la série
  final DateTime createdAt;
  final DateTime updatedAt;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.mode,
    required this.difficulty,
    required this.questions,
    this.imageUrl,
    this.tags = const [],
    this.isPremium = false,
    this.requiredTier,
    this.estimatedMinutes = 10,
    this.seriesId,
    this.orderInSeries,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: QuizType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => QuizType.fun,
      ),
      mode: QuizMode.values.firstWhere(
        (e) => e.name == json['mode'],
        orElse: () => QuizMode.solo,
      ),
      difficulty: QuizDifficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
        orElse: () => QuizDifficulty.medium,
      ),
      questions: (json['questions'] as List<dynamic>)
          .map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList(),
      imageUrl: json['imageUrl'] as String?,
      tags: List<String>.from(json['tags'] ?? []),
      isPremium: json['isPremium'] as bool? ?? false,
      requiredTier: json['requiredTier'] as String?,
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 10,
      seriesId: json['seriesId'] as String?,
      orderInSeries: json['orderInSeries'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'mode': mode.name,
      'difficulty': difficulty.name,
      'questions': questions.map((q) => q.toJson()).toList(),
      'imageUrl': imageUrl,
      'tags': tags,
      'isPremium': isPremium,
      'requiredTier': requiredTier,
      'estimatedMinutes': estimatedMinutes,
      'seriesId': seriesId,
      'orderInSeries': orderInSeries,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Quiz copyWith({
    String? id,
    String? title,
    String? description,
    QuizType? type,
    QuizMode? mode,
    QuizDifficulty? difficulty,
    List<Question>? questions,
    String? imageUrl,
    List<String>? tags,
    bool? isPremium,
    String? requiredTier,
    int? estimatedMinutes,
    String? seriesId,
    int? orderInSeries,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      mode: mode ?? this.mode,
      difficulty: difficulty ?? this.difficulty,
      questions: questions ?? this.questions,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      isPremium: isPremium ?? this.isPremium,
      requiredTier: requiredTier ?? this.requiredTier,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      seriesId: seriesId ?? this.seriesId,
      orderInSeries: orderInSeries ?? this.orderInSeries,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
