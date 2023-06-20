import 'dart:convert';

class BaseResponse {
  bool success;
  String message;
  dynamic data;

  BaseResponse({required this.success, required this.message, this.data});

  factory BaseResponse.fromJson(String str) =>
      BaseResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());
  factory BaseResponse.fromMap(Map<String, dynamic> json) => BaseResponse(
        success: json['success'],
        message: json['message'],
        data: json['data'],
      );

  Map<String, dynamic> toMap() {
    data['success'] = success;
    data['message'] = message;
    data['data'] = data;
    return data;
  }
}
