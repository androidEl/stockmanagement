import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:stockmanagement/controller/crud_controller.dart';

var firestore = FirebaseFirestore.instance;

class ProductRecord {
  String category;
  String img;
  String kode;
  String name;
  int price;
  int stock;

  ProductRecord(
      this.category, this.img, this.kode, this.name, this.price, this.stock);

  ProductRecord.map(dynamic obj) {
    this.name = obj['name'];
    this.kode = obj['kode'];
    this.price = obj['price'];
    this.stock = obj['stock'];
    this.category = obj['category'];
    this.img = obj['img'];
  }

  //getter
  String get productName => name;
  String get productCode => kode;
  String get productStock => stock.toString();
  String get productCategory => category;
  String get productImg => img;
  String get producPrice => price.toString();

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['name'] = name;
    map['kode'] = kode;
    map['price'] = price;
    map['stock'] = stock;
    map['category'] = category;
    map['img'] = img;
  }

  ProductRecord.fromMap(Map<String, dynamic> map) {
    this.name = map['name'];
    this.kode = map['kode'];
    this.price = map['price'];
    this.stock = map['stock'];
    this.category = map['category'];
    this.img = map['img'];
  }
}
