// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'count_model.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    required this.orderId,
    required this.userId,
    required this.totalPrice,
    required this.orderDateTime,
    required this.createdAt,
    required this.updatedAt,
    required this.count,
  });

  int orderId;
  int userId;
  int totalPrice;
  DateTime orderDateTime;
  DateTime createdAt;
  DateTime updatedAt;
  Count count;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["orderId"],
        userId: json["userId"],
        totalPrice: json["totalPrice"],
        orderDateTime: DateTime.parse(json["orderDateTime"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        count: Count.fromJson(json["_count"]),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "userId": userId,
        "totalPrice": totalPrice,
        "orderDateTime": orderDateTime.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "_count": count.toJson(),
      };
}
