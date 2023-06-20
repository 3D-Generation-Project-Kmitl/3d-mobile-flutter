// To parse this JSON data, do
//
//     final wallet = walletFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Wallet walletFromJson(String str) => Wallet.fromJson(json.decode(str));

String walletToJson(Wallet data) => json.encode(data.toJson());

class Wallet {
  Wallet({
    required this.walletTransactions,
    required this.balance,
  });

  List<WalletTransaction> walletTransactions;
  int balance;

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        walletTransactions: List<WalletTransaction>.from(
            json["walletTransactions"]
                .map((x) => WalletTransaction.fromJson(x))),
        balance: json["balance"],
      );

  Map<String, dynamic> toJson() => {
        "walletTransactions":
            List<dynamic>.from(walletTransactions.map((x) => x.toJson())),
        "balance": balance,
      };
}

class WalletTransaction {
  WalletTransaction({
    required this.walletTransactionId,
    required this.userId,
    required this.amountMoney,
    required this.type,
    required this.status,
    required this.evidence,
    required this.createdAt,
    required this.updatedAt,
  });

  int walletTransactionId;
  int userId;
  int amountMoney;
  String type;
  String status;
  dynamic evidence;
  DateTime createdAt;
  DateTime updatedAt;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) =>
      WalletTransaction(
        walletTransactionId: json["walletTransactionId"],
        userId: json["userId"],
        amountMoney: json["amountMoney"],
        type: json["type"],
        status: json["status"],
        evidence: json["evidence"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "walletTransactionId": walletTransactionId,
        "userId": userId,
        "amountMoney": amountMoney,
        "type": type,
        "status": status,
        "evidence": evidence,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
