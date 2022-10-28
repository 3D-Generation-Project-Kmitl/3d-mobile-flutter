import 'dart:convert';
import 'response_model.dart';

class User {
  final int userId;
  final String email;
  final String name;
  final String? gAuthCode;
  final String? picture;
  final String? gender;
  final String? dateOfBirth;
  final bool isVerified;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.userId,
    required this.email,
    required this.name,
    this.gAuthCode,
    this.picture,
    this.gender,
    this.dateOfBirth,
    required this.isVerified,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        userId: json["userId"],
        email: json["email"],
        name: json["name"],
        gAuthCode: json["gAuthCode"],
        picture: json["picture"],
        gender: json["gender"],
        dateOfBirth: json["dateOfBirth"],
        isVerified: json["isVerified"],
        role: json["role"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toMap() => {
        "userId": userId,
        "email": email,
        "name": name,
        "gAuthCode": gAuthCode,
        "picture": picture,
        "gender": gender,
        "dateOfBirth": dateOfBirth,
        "isVerified": isVerified,
        "role": role,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
