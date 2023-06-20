// To parse this JSON data, do
//
//     final errorModel = errorModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ErrorModel errorModelFromJson(String str) =>
    ErrorModel.fromJson(json.decode(str));

String errorModelToJson(ErrorModel data) => json.encode(data.toJson());

class ErrorModel {
  ErrorModel({
    required this.error,
    required this.success,
    required this.message,
  });

  Error error;
  bool success;
  String message;

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        error: Error.fromJson(json["error"]),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "error": error.toJson(),
        "success": success,
        "message": message,
      };
}

class Error {
  Error({
    required this.name,
    required this.type,
    required this.code,
    required this.message,
  });

  String name;
  String type;
  String code;
  String message;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        name: json["name"],
        type: json["type"],
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "code": code,
        "message": message,
      };
}
