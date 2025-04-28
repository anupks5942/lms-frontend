class Teacher {
  String? id;
  String? name;

  Teacher({this.id, this.name});

  Teacher copyWith({String? id, String? name}) => Teacher(id: id ?? this.id, name: name ?? this.name);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["_id"] = id;
    map["name"] = name;
    return map;
  }

  Teacher.fromJson(dynamic json){
    id = json["_id"] ?? "";
    name = json["name"] ?? "";
  }
}

class Course {
  String? id;
  String? title;
  String? description;
  Teacher? teacher;
  List<dynamic>? studentsList;
  String? createdAt;
  num? v;

  Course({this.id, this.title, this.description, this.teacher, this.studentsList, this.createdAt, this.v});

  Course copyWith({String? id, String? title, String? description, Teacher? teacher, List<
      dynamic>? studentsList, String? createdAt, num? v}) =>
      Course(id: id ?? this.id,
          title: title ?? this.title,
          description: description ?? this.description,
          teacher: teacher ?? this.teacher,
          studentsList: studentsList ?? this.studentsList,
          createdAt: createdAt ?? this.createdAt,
          v: v ?? this.v);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["_id"] = id;
    map["title"] = title;
    map["description"] = description;
    if (teacher != null) {
      map["teacher"] = teacher?.toJson();
    }
    if (studentsList != null) {
      map["students"] = studentsList?.map((v) => v.toJson()).toList();
    }
    map["createdAt"] = createdAt;
    map["__v"] = v;
    return map;
  }

  Course.fromJson(dynamic json){
    id = json["_id"] ?? "";
    title = json["title"] ?? "";
    description = json["description"] ?? "";
    teacher = json["teacher"] != null ? Teacher.fromJson(json["teacher"]) : null;
    if (json["students"] != null) {
      studentsList = [];
    }
    createdAt = json["createdAt"] ?? "";
    v = json["__v"] ?? 0;
  }
}