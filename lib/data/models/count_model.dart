class Count {
  Count({
    this.orderProduct = 0,
    this.favorite = 0,
  });

  int orderProduct;
  int favorite;

  factory Count.fromJson(Map<String, dynamic> json) => Count(
        orderProduct: json["OrderProduct"] ?? 0,
        favorite: json["Favorite"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "OrderProduct": orderProduct,
        "Favorite": favorite,
      };
}
