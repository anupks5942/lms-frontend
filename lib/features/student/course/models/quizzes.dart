
class Quiz {
  final String id;
  final String title;
  final String course;
  final List<Question> questions;
  final CreatedBy createdBy;
  final DateTime createdAt;

  Quiz({
    required this.id,
    required this.title,
    required this.course,
    required this.questions,
    required this.createdBy,
    required this.createdAt,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      course: json['course'] as String? ?? '',
      questions: (json['questions'] as List<dynamic>?)
              ?.map((q) => Question.fromJson(q as Map<String, dynamic>))
              .toList() ??
          [],
      createdBy: CreatedBy.fromJson(json['createdBy'] as Map<String, dynamic>? ?? {}),
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'course': course,
      'questions': questions.map((q) => q.toJson()).toList(),
      'createdBy': createdBy.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class Question {
  final String id;
  final String questionText;
  final String type;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.id,
    required this.questionText,
    required this.type,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'] as String? ?? '',
      questionText: json['questionText'] as String? ?? '',
      type: json['type'] as String? ?? '',
      options: (json['options'] as List<dynamic>?)?.cast<String>() ?? [],
      correctAnswer: json['correctAnswer'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'questionText': questionText,
      'type': type,
      'options': options,
      'correctAnswer': correctAnswer,
    };
  }
}

class CreatedBy {
  final String id;
  final String name;

  CreatedBy({
    required this.id,
    required this.name,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}
