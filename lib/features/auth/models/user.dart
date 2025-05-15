class AuthModel {
  final String token;
  final User user;

  AuthModel({required this.token, required this.user});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'token': token, 'user': user.toJson()};
  }

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(token: json['token'], user: User.fromJson(json['user']));
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String role;

  User({this.id = '', this.name = '', this.email = '', this.role = ''});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'_id': id, 'name': name, 'email': email, 'token': role};
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['_id'], name: json['name'], email: json['email'], role: json['role']);
  }
}
