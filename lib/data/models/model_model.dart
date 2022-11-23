// To parse this JSON data, do
//
//     final model = modelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Model modelFromJson(String str) => Model.fromJson(json.decode(str));

String modelToJson(Model data) => json.encode(data.toJson());

class Model {
  Model({
    required this.modelId,
    required this.userId,
    required this.model,
    required this.picture,
    required this.status,
    required this.type,
    this.createdAt,
    this.updatedAt,
  });

  int modelId;
  int userId;
  String model;
  dynamic picture;
  String status;
  String type;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        modelId: json["modelId"],
        userId: json["userId"],
        model: json["model"],
        picture: json["picture"],
        status: json["status"],
        type: json["type"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "modelId": modelId,
        "userId": userId,
        "model": model,
        "picture": picture,
        "status": status,
        "type": type,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
