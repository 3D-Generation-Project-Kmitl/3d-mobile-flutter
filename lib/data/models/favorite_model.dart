import 'package:meta/meta.dart';
import 'dart:convert';

import 'models.dart';

Favorite favoriteFromJson(String str) => Favorite.fromJson(json.decode(str));

String favoriteToJson(Favorite data) => json.encode(data.toJson());

class Favorite {
  Favorite({
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

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
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
