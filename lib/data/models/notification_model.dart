// To parse this JSON data, do
//
//     final notification = notificationFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

NotificationModel notificationFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.picture,
    required this.title,
    required this.description,
    required this.link,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  int notificationId;
  int userId;
  String picture;
  String title;
  String description;
  String link;
  bool isRead;
  DateTime createdAt;
  DateTime updatedAt;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        notificationId: json["notificationId"],
        userId: json["userId"],
        picture: json["picture"],
        title: json["title"],
        description: json["description"],
        link: json["link"],
        isRead: json["isRead"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "notificationId": notificationId,
        "userId": userId,
        "picture": picture,
        "title": title,
        "description": description,
        "link": link,
        "isRead": isRead,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
