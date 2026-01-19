enum QuestionType {
  multipleChoice, // Choix multiple (une seule réponse)
  scale, // Échelle (1-5)
  yesNo, // Oui/Non
  multiSelect, // Plusieurs réponses possibles
}

class Question {
  final String id;
  final String text;
  final QuestionType type;
  final List<Answer> answers;
  final String? imageUrl;
  final String? explanation; // Explication après réponse
  final int order;

  Question({
    required this.id,
    required this.text,
    required this.type,
    required this.answers,
    this.imageUrl,
    this.explanation,
    required this.order,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      text: json['text'] as String,
      type: QuestionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => QuestionType.multipleChoice,
      ),
      answers: (json['answers'] as List<dynamic>)
          .map((a) => Answer.fromJson(a as Map<String, dynamic>))
          .toList(),
      imageUrl: json['imageUrl'] as String?,
      explanation: json['explanation'] as String?,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type.name,
      'answers': answers.map((a) => a.toJson()).toList(),
      'imageUrl': imageUrl,
      'explanation': explanation,
      'order': order,
    };
  }
}

class Answer {
  final String id;
  final String text;
  final int value; // Pour les scores (1-5 pour échelles)
  final String? category; // Pour catégoriser les réponses (personnalité)

  Answer({
    required this.id,
    required this.text,
    required this.value,
    this.category,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'] as String,
      text: json['text'] as String,
      value: json['value'] as int,
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'value': value,
      'category': category,
    };
  }
}
