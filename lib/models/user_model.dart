import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final int? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? avatar;
  bool favourite;

  User({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.avatar,
    this.favourite = false,
  });

  User copyWith({
    int? id,
    String? email,
    String? firstName,
    String? lastName,
    String? avatar,
    bool? favourite,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
      favourite: favourite ?? this.favourite,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      email: json["email"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      avatar: json["avatar"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
      "avatar": avatar,
      "favourite": favourite,
    };
  }
}
