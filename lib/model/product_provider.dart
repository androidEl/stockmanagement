/*
 * Copyright (c) 2020.
 * Written by Elham Yudhisira
 * Enjoy the game
 */

import 'package:flutter/cupertino.dart';

class ProductProvider with ChangeNotifier {
  String name;
  String kode;
  String category;
  int price;
  int stock;
  String img;

  ProductProvider(
      this.name, this.kode, this.category, this.price, this.stock, this.img);

  //getter
  String get getName => name;
}
