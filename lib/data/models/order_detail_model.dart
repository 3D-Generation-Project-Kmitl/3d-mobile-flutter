// To parse this JSON data, do
//
//     final orderDetail = orderDetailFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';
import './product_model.dart';

OrderDetail orderDetailFromJson(String str) =>
    OrderDetail.fromJson(json.decode(str));

String orderDetailToJson(OrderDetail data) => json.encode(data.toJson());

class OrderDetail {
  OrderDetail({
    required this.orderId,
    required this.userId,
    required this.totalPrice,
    required this.orderDateTime,
    required this.createdAt,
    required this.updatedAt,
    required this.orderProduct,
  });

  int orderId;
  int userId;
  int totalPrice;
  DateTime orderDateTime;
  DateTime createdAt;
  DateTime updatedAt;
  List<OrderProduct> orderProduct;

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        orderId: json["orderId"],
        userId: json["userId"],
        totalPrice: json["totalPrice"],
        orderDateTime: DateTime.parse(json["orderDateTime"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        orderProduct: List<OrderProduct>.from(
            json["OrderProduct"].map((x) => OrderProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "userId": userId,
        "totalPrice": totalPrice,
        "orderDateTime": orderDateTime.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "OrderProduct": List<dynamic>.from(orderProduct.map((x) => x.toJson())),
      };
}

class OrderProduct {
  OrderProduct({
    required this.orderId,
    required this.productId,
    required this.price,
    required this.comment,
    required this.score,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  int orderId;
  int productId;
  int price;
  dynamic comment;
  dynamic score;
  DateTime createdAt;
  DateTime updatedAt;
  Product product;

  factory OrderProduct.fromJson(Map<String, dynamic> json) => OrderProduct(
        orderId: json["orderId"],
        productId: json["productId"],
        price: json["price"],
        comment: json["comment"],
        score: json["score"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        product: Product.fromJson(json["Product"]),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "productId": productId,
        "price": price,
        "comment": comment,
        "score": score,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "Product": product.toJson(),
      };
}
