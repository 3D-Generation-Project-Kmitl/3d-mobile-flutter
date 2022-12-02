// To parse this JSON data, do
//
//     final cart = cartFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'models.dart';

Cart cartFromJson(String str) => Cart.fromJson(json.decode(str));

String cartToJson(Cart data) => json.encode(data.toJson());

class Cart {
  Cart({
    required this.userId,
    required this.productId,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  int userId;
  int productId;
  DateTime createdAt;
  DateTime updatedAt;
  Product product;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        userId: json["userId"],
        productId: json["productId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        product: Product.fromJson(json["Product"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "productId": productId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "Product": product.toJson(),
      };
}
