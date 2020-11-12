import 'dart:convert';

DataProduct dataProductFromJson(String str) =>
    DataProduct.fromJson(json.decode(str));

String dataProductToJson(DataProduct data) => json.encode(data.toJson());

class DataProduct {
  DataProduct({
    this.category,
    this.name,
    this.price,
    this.stock,
    this.imgProduct,
  });

  String category;
  String name;
  String price;
  String stock;
  String imgProduct;

  factory DataProduct.fromJson(Map<String, dynamic> json) => DataProduct(
        category: json["category"],
        name: json["name"],
        price: json["price"],
        stock: json["stock"],
        imgProduct: json["imgProduct"],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "name": name,
        "price": price,
        "stock": stock,
        "imgProduct": imgProduct,
      };
}
