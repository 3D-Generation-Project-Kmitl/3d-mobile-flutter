// To parse this JSON data, do
//
//     final identity = identityFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Identity identityFromJson(String str) => Identity.fromJson(json.decode(str));

String identityToJson(Identity data) => json.encode(data.toJson());

class Identity {
  Identity({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.idCardNumber,
    required this.cardPicture,
    required this.cardFacePicture,
    required this.bankName,
    required this.bankAccount,
    required this.status,
    this.issue,
    required this.createdAt,
    required this.updatedAt,
  });

  int userId;
  String firstName;
  String lastName;
  String phone;
  String idCardNumber;
  String cardPicture;
  String cardFacePicture;
  String bankName;
  String bankAccount;
  String status;
  String? issue;
  DateTime createdAt;
  DateTime updatedAt;

  factory Identity.fromJson(Map<String, dynamic> json) => Identity(
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        phone: json["phone"],
        idCardNumber: json["idCardNumber"],
        cardPicture: json["cardPicture"],
        cardFacePicture: json["cardFacePicture"],
        bankName: json["bankName"],
        bankAccount: json["bankAccount"],
        status: json["status"],
        issue: json["issue"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
        "idCardNumber": idCardNumber,
        "cardPicture": cardPicture,
        "cardFacePicture": cardFacePicture,
        "bankName": bankName,
        "bankAccount": bankAccount,
        "status": status,
        "issue": issue,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
