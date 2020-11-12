class ItemModel {
  int _id;
  String _itemCode;
  String _itemName;
  int _itemStock;
  int _itemPrice;
  String _itemAvatar;

  ItemModel(this._itemCode, this._itemName, this._itemStock, this._itemPrice,
      this._itemAvatar);

  ItemModel.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._itemCode = map['sku'];
    this._itemName = map['name'];
    this._itemStock = map['stock'];
    this._itemPrice = map['price'];
    this._itemAvatar = map['productImg'];
  }

  String get imgProduct => _itemAvatar;

  set imgProduct(String value) {
    _itemAvatar = value;
  }

  int get price => _itemPrice;

  set price(int value) {
    _itemPrice = value;
  }

  int get stock => _itemStock;

  set stock(int value) {
    _itemStock = value;
  }

  String get name => _itemName;

  set name(String value) {
    _itemName = value;
  }

  String get sku => _itemCode;

  set sku(String value) {
    _itemCode = value;
  }

  int get id => _id;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['sku'] = this.sku;
    map['name'] = this.name;
    map['stock'] = this.stock;
    map['price'] = this.price;
    map['productImg'] = this.imgProduct;
    return map;
  }
}
