class Teacher {
  final String id;
  final String name;

  Teacher({required this.id, this.name = ''});

  factory Teacher.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Teacher(id: '');
    }
    return Teacher(id: json['_id'] as String? ?? '', name: json['name'] as String? ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}

class Student {
  final String id;
  final String name;

  Student({required this.id, this.name = ''});

  factory Student.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Student(id: '');
    }
    return Student(id: json['_id'] as String? ?? '', name: json['name'] as String? ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}

class Course {
  final String id;
  final String title;
  final String description;
  final Teacher teacher;
  final List<Student> students;
  final DateTime createdAt;

  Course({
    required this.id,
    this.title = '',
    this.description = '',
    required this.teacher,
    this.students = const [],
    required this.createdAt,
  });

  factory Course.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Course(id: '', teacher: Teacher(id: ''), createdAt: DateTime.now());
    }

    final teacherJson = json['teacher'] as Map<String, dynamic>?;
    final teacher = Teacher.fromJson(teacherJson);

    final studentsJson = json['students'] as List<dynamic>? ?? [];
    final students =
        studentsJson.whereType<Map<String, dynamic>>().map((student) => Student.fromJson(student)).toList();

    return Course(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      teacher: teacher,
      students: students,
      createdAt: _parseDateTime(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'teacher': teacher.toJson(),
      'students': students.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static DateTime _parseDateTime(dynamic date) {
    if (date == null) return DateTime.now();
    try {
      return DateTime.parse(date as String);
    } catch (e) {
      return DateTime.now();
    }
  }
}
