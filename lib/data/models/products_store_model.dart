// To parse this JSON data, do
//
//     final productsStore = productsStoreFromJson(jsonString);

import 'package:marketplace/data/models/count_user_model.dart';
import 'package:meta/meta.dart';
import 'product_model.dart';
import 'dart:convert';

ProductsStore productsStoreFromJson(String str) =>
    ProductsStore.fromJson(json.decode(str));

String productsStoreToJson(ProductsStore data) => json.encode(data.toJson());

class ProductsStore {
  ProductsStore({
    required this.userId,
    required this.email,
    required this.name,
    required this.gAuthCode,
    required this.picture,
    required this.gender,
    required this.dateOfBirth,
    required this.isVerified,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.products,
    this.count,
  });

  final int userId;
  final String email;
  final String name;
  final String? gAuthCode;
  final String? picture;
  final String? gender;
  final DateTime? dateOfBirth;
  final bool isVerified;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  List<Product> products;
  CountUser? count;

  factory ProductsStore.fromJson(Map<String, dynamic> json) => ProductsStore(
        userId: json["userId"],
        email: json["email"],
        name: json["name"],
        gAuthCode: json["gAuthCode"],
        picture: json["picture"],
        gender: json["gender"],
        dateOfBirth: json["dateOfBirth"] == null
            ? null
            : DateTime.parse(json["dateOfBirth"]),
        isVerified: json["isVerified"],
        role: json["role"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        products:
            List<Product>.from(json["Product"].map((x) => Product.fromJson(x))),
        count:
            json["_count"] == null ? null : CountUser.fromJson(json["_count"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "email": email,
        "name": name,
        "gAuthCode": gAuthCode,
        "picture": picture,
        "gender": gender,
        "dateOfBirth": dateOfBirth?.toIso8601String(),
        "isVerified": isVerified,
        "role": role,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "Product": List<dynamic>.from(products.map((x) => x.toJson())),
        "_count": count?.toJson(),
      };
}
