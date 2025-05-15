class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String role;
  final DateTime createdAt;

  User({
    required this.id,
    this.name = '',
    this.email = '',
    this.password = '',
    this.role = 'student',
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      role: json['role'] as String? ?? 'student',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class Teacher {
  final String id;
  final String name;

  Teacher({required this.id, this.name = ''});

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(id: json['_id'] as String, name: json['name'] as String? ?? '');
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
  final List<User> students;
  final DateTime createdAt;

  Course({
    required this.id,
    this.title = '',
    this.description = '',
    required this.teacher,
    this.students = const [],
    required this.createdAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      teacher: Teacher.fromJson(json['teacher'] as Map<String, dynamic>),
      students:
          (json['students'] as List<dynamic>?)?.map((e) => User.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      createdAt: DateTime.parse(json['createdAt'] as String),
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
}
