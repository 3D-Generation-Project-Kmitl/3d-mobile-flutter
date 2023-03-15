// To parse this JSON data, do
//
//     final following = followingFromJson(jsonString);

import 'package:marketplace/data/models/models.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

Following followingFromJson(String str) => Following.fromJson(json.decode(str));

String followingToJson(Following data) => json.encode(data.toJson());

class Following {
  Following({
    required this.followerId,
    required this.followedId,
    required this.createdAt,
    required this.updatedAt,
    required this.followed,
  });

  int followerId;
  int followedId;
  DateTime createdAt;
  DateTime updatedAt;
  User followed;

  factory Following.fromJson(Map<String, dynamic> json) => Following(
        followerId: json["followerId"],
        followedId: json["followedId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        followed: User.fromJson(json["Followed"]),
      );

  Map<String, dynamic> toJson() => {
        "followerId": followerId,
        "followedId": followedId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "Followed": followed.toJson(),
      };
}
