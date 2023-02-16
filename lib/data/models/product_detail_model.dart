// To parse this JSON data, do
//
//     final productDetail = productDetailFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';
import './models.dart';

ProductDetail productDetailFromJson(String str) =>
    ProductDetail.fromJson(json.decode(str));

String productDetailToJson(ProductDetail data) => json.encode(data.toJson());

class ProductDetail {
  ProductDetail({
    required this.productId,
    required this.userId,
    required this.modelId,
    required this.categoryId,
    required this.name,
    required this.details,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.model,
    required this.user,
    required this.category,
  });

  int productId;
  int userId;
  int modelId;
  int categoryId;
  String name;
  String details;
  int price;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  Model model;
  User user;
  Category category;

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
        productId: json["productId"],
        userId: json["userId"],
        modelId: json["modelId"],
        categoryId: json["categoryId"],
        name: json["name"],
        details: json["details"],
        price: json["price"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        model: Model.fromJson(json["Model"]),
        user: User.fromJson(json["User"]),
        category: Category.fromJson(json["Category"]),
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "userId": userId,
        "modelId": modelId,
        "categoryId": categoryId,
        "name": name,
        "details": details,
        "price": price,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "Model": model.toJson(),
        "User": user.toJson(),
        "Category": category.toJson(),
      };
}
