import 'package:meta/meta.dart';
import 'dart:convert';
import './model_model.dart';
import 'category_model.dart';
import 'count_model.dart';

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
    required this.views,
    this.createdAt,
    this.updatedAt,
    required this.model,
    this.category,
    this.count,
  });

  int productId;
  int userId;
  int modelId;
  int categoryId;
  String name;
  String details;
  int price;
  String status;
  int views;
  DateTime? createdAt;
  DateTime? updatedAt;
  Model model;
  Category? category;
  Count? count;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["productId"],
        userId: json["userId"],
        modelId: json["modelId"],
        categoryId: json["categoryId"],
        name: json["name"],
        details: json["details"],
        price: json["price"],
        status: json["status"],
        views: json["views"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        model: Model.fromJson(json["Model"]),
        category: json["Category"] == null
            ? null
            : Category.fromJson(json["Category"]),
        count: json["_count"] == null ? null : Count.fromJson(json["_count"]),
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
        "views": views,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "Model": model.toJson(),
        "Category": category == null ? null : category!.toJson(),
        "_count": count == null ? null : count!.toJson(),
      };
}
