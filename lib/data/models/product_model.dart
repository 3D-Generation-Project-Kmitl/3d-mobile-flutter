import 'package:meta/meta.dart';
import 'dart:convert';
import './model_model.dart';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    required this.productId,
    required this.userId,
    required this.modelId,
    required this.categoryId,
    required this.name,
    required this.details,
    required this.price,
    required this.status,
    this.createdAt,
    this.updatedAt,
    required this.model,
  });

  int productId;
  int userId;
  int modelId;
  int categoryId;
  String name;
  String details;
  int price;
  String status;
  DateTime? createdAt;
  DateTime? updatedAt;
  Model model;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
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
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "Model": model.toJson(),
      };
}
