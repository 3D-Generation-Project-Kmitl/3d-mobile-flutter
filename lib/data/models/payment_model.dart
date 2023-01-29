// To parse this JSON data, do
//
//     final payment = paymentFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Payment paymentFromJson(String str) => Payment.fromJson(json.decode(str));

String paymentToJson(Payment data) => json.encode(data.toJson());

class Payment {
  Payment({
    required this.paymentIntent,
    required this.ephemeralKey,
    required this.customer,
  });

  String paymentIntent;
  String ephemeralKey;
  String customer;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        paymentIntent: json["paymentIntent"],
        ephemeralKey: json["ephemeralKey"],
        customer: json["customer"],
      );

  Map<String, dynamic> toJson() => {
        "paymentIntent": paymentIntent,
        "ephemeralKey": ephemeralKey,
        "customer": customer,
      };
}
