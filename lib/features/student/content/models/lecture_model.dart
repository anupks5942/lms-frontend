class Lecture {
  final String id;
  final String title;
  final String description;
  final String youtubeLink;

  Lecture({
    required this.id,
    required this.title,
    required this.description,
    required this.youtubeLink,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      youtubeLink: json['youtubeLink'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'youtubeLink': youtubeLink,
    };
  }
}
