// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'package:marketplace/data/models/count_user_model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final int userId;
  final String email;
  final String name;
  final String? gAuthCode;
  final String? picture;
  final String? gender;
  final DateTime? dateOfBirth;
  final bool isVerified;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  CountUser? count;

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
    this.count,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["userId"],
        email: json["email"],
        name: json["name"],
        gAuthCode: json["gAuthCode"],
        picture: json["picture"],
        gender: json["gender"],
        dateOfBirth: json["dateOfBirth"] == null
            ? null
            : DateTime.parse(json["dateOfBirth"]),
        isVerified: json["isVerified"],
        role: json["role"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        count:
            json["_count"] == null ? null : CountUser.fromJson(json["_count"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "email": email,
        "name": name,
        "gAuthCode": gAuthCode,
        "picture": picture,
        "gender": gender,
        "dateOfBirth": dateOfBirth?.toIso8601String(),
        "isVerified": isVerified,
        "role": role,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "_count": count == null ? null : count!.toJson(),
      };
}
