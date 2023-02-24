// To parse this JSON data, do
//
//     final follower = followerFromJson(jsonString);

import 'package:marketplace/data/models/models.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

Follower followerFromJson(String str) => Follower.fromJson(json.decode(str));

String followerToJson(Follower data) => json.encode(data.toJson());

class Follower {
  Follower({
    required this.followerId,
    required this.followedId,
    required this.createdAt,
    required this.updatedAt,
    required this.follower,
  });

  int followerId;
  int followedId;
  DateTime createdAt;
  DateTime updatedAt;
  User follower;

  factory Follower.fromJson(Map<String, dynamic> json) => Follower(
        followerId: json["followerId"],
        followedId: json["followedId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        follower: User.fromJson(json["Follower"]),
      );

  Map<String, dynamic> toJson() => {
        "followerId": followerId,
        "followedId": followedId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "Follower": follower.toJson(),
      };
}
