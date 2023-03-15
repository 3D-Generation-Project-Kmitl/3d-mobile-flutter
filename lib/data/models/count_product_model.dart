class CountProduct {
  CountProduct({
    this.orderProduct = 0,
    this.favorite = 0,
  });

  int orderProduct;
  int favorite;

  factory CountProduct.fromJson(Map<String, dynamic> json) => CountProduct(
        orderProduct: json["OrderProduct"] ?? 0,
        favorite: json["Favorite"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "OrderProduct": orderProduct,
        "Favorite": favorite,
      };
}
