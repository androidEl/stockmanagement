import 'package:sqflite/sqflite.dart';
import 'package:stockmanagement/model/item_model.dart';

import 'db_helper.dart';

class CRUD {
  static const productTable = 'product';
  static const id = 'id';
  static const sku = 'sku';
  static const nameProduct = 'name';
  static const stockProduct = 'stock';
  static const priceProduct = 'price';
  static const imgProduct = 'productImg';
  DbHelper dbHelper = new DbHelper();

  Future<int> insert(ItemModel product) async {
    Database db = await dbHelper.initDb();
    final sql =
        '''INSERT INTO ${CRUD.productTable} (${CRUD.sku},${CRUD.nameProduct},${CRUD.stockProduct},${CRUD.priceProduct},${CRUD.imgProduct}) VALUES (?,?,?,?,?)''';
    List<dynamic> params = [
      product.sku,
      product.name,
      product.stock,
      product.price,
      product.imgProduct
    ];
    final result = await db.rawInsert(sql, params);
    return result;
  }

  Future<int> update(ItemModel product) async {
    Database db = await dbHelper.initDb();
    int result = await db.update(productTable, product.toMap(),
        where: 'id=?', whereArgs: [product.id]);
    return result;
  }

  Future<int> delete(ItemModel product) async {
    Database db = await dbHelper.initDb();
    int result =
        await db.delete(productTable, where: 'id=?', whereArgs: [product.id]);
    return result;
  }

  Future<List<ItemModel>> getProductList() async {
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> mapList =
        await db.query(productTable, orderBy: 'name');
    int count = mapList.length;
    List<ItemModel> products = List<ItemModel>();
    for (int i = 0; i < count; i++) {
      products.add(ItemModel.fromMap(mapList[i]));
    }
    return products;
  }

  Future<List<ItemModel>> searchProduct(String params) async {
    Database db = await dbHelper.initDb();
    final sql = '''
      SELECT * FROM ${CRUD.productTable} WHERE ${CRUD.nameProduct} LIKE ?
    ''';
    List<dynamic> parameter = ['$params%'];
    List<Map<String, dynamic>> mapList = await db.rawQuery(sql, parameter);
    int count = mapList.length;
    List<ItemModel> products = List<ItemModel>();
    for (int i = 0; i < count; i++) {
      products.add(ItemModel.fromMap(mapList[i]));
    }
    return products;
  }

  Future<int> updateProduct(
      ItemModel product, String name, int stock, int price) async {
    Database db = await dbHelper.initDb();
    final sql = '''
      UPDATE ${CRUD.productTable} SET
      ${CRUD.nameProduct} = ?,
      ${CRUD.stockProduct} = ?,
      ${CRUD.priceProduct} = ?
      WHERE ${CRUD.id} = ?
    ''';
    List<dynamic> params = [name, stock, price, product.id];
    final result = db.rawUpdate(sql, params);
    return result;
  }
}
