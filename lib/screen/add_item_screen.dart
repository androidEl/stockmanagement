import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockmanagement/controller/crud_controller.dart';
import 'package:stockmanagement/database/crud.dart';
import 'package:stockmanagement/database/db_helper.dart';
import 'package:stockmanagement/database/firebaseDb.dart';
import 'package:stockmanagement/model/item_model.dart';
import 'package:stockmanagement/screen/item_screen.dart';
import 'package:stockmanagement/screen/main_screen.dart';

class AddItemScreen extends StatefulWidget {
  static String id = 'AddItemScreen';

  final bool isEdit;
  final String documentId;
  final String name;
  final String code;
  final String stock;
  final String price;
  final String category;
  final String img;

  const AddItemScreen(this.isEdit, this.documentId, this.name, this.code,
      this.stock, this.price, this.category, this.img);

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  ItemModel product;
  File _image;
  DbHelper dbHelper;
  String imgString;
  List<int> imgBytes;
  CRUD dbConf = CRUD();
  int _id = 0;
  var storage = FirebaseStorage.instance;
  User user = FirebaseAuth.instance.currentUser;

  String categoryItem;
  List categoryValue = [
    "Bagcharm",
    "Bracelet",
    "Necklace",
    "Glasses Strap",
    "Phone Charm",
    "Lanyard",
    "Bookmark",
    "Pins",
    "Earrings"
  ];

  TextEditingController codeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();

  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  Future getImageFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        print(pickedFile.path);
        _image = File(pickedFile.path);
        imgString = base64Encode(_image.readAsBytesSync());
      });
      Navigator.of(context).pop(false);
    } else {
      Navigator.of(context).pop(false);
    }
  }

  Future getImageFromGalery() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        imgString = base64Encode(_image.readAsBytesSync());
      });
      print(imgString);
      Navigator.of(context).pop(false);
    } else {
      Navigator.of(context).pop(false);
    }
  }

  Future<bool> _alertDeleteProduct() {
    return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              title: new Text("Yakin Mau di Hapus?"),
              content: new Text('yakin mau hapus ${product.name} ?'),
              actions: <Widget>[
                GestureDetector(
                  child: Container(
                    child: Text("Yes"),
                  ),
                  onTap: () async {
                    int result = await dbConf.delete(product);

                    if (result > 0) {
                      Navigator.pushReplacementNamed(context, MainScreen.id);
                    }
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  child: Container(
                    child: Text("No"),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  Future<bool> _openChooseImage() {
    return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              title: new Text("Pilih Gambar"),
              content: Container(
                height: 100,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            getImageFromGalery();
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.image),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text('Pilih dari koleksi gambar'),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            getImageFromCamera();
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.camera_alt),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text('Ambil dari kamera'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isEdit) {
      setState(() {
        codeController.text = widget.code;
        nameController.text = widget.name;
        priceController.text = widget.price;
        stockController.text = widget.stock;
        imgString = widget.img;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: widget.isEdit == false
            ? Text('Tambah Product')
            : Text('Ubah Product'),
        leading: GestureDetector(
          child: Icon(Icons.keyboard_arrow_left),
          onTap: () => Navigator.pushReplacementNamed(context, MainScreen.id),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacementNamed(context, MainScreen.id);
          return Future.value(false);
        },
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 2.5,
                padding: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: codeController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Kode Produk',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                    Spacer(),
                    TextField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Nama Produk',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                    Spacer(),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Harga Produk',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                    Spacer(),
                    TextField(
                      controller: stockController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Stok Produk',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 3, bottom: 3),
                child: Container(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text("Select Category"),
                    value: categoryItem,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black87, fontSize: 18),
                    items: categoryValue.map((value) {
                      return DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                    onChanged: ((value) {
                      setState(() {
                        categoryItem = value;
                      });
                    }),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(right: 10, left: 10),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.blueAccent)),
                  color: Colors.white,
                  textColor: Colors.blueAccent,
                  onPressed: _openChooseImage,
                  child: Text(
                    "Pilih gambar",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              widget.isEdit == false
                  ? _image == null
                      ? Container(
                          height: MediaQuery.of(context).size.height / 4,
                          width: MediaQuery.of(context).size.width / 1.2,
                          padding: EdgeInsets.all(8),
                          color: Colors.grey,
                          child: Center(child: Icon(Icons.image)),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height / 4,
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Image.file(_image),
                        )
                  : Container(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Image.memory(base64Decode(imgString)),
                    ),
              Container(
                padding: EdgeInsets.only(top: 8, right: 10, left: 10),
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 15,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    if (widget.isEdit == false) {
                      uploadImage(
                          _image.path,
                          user.uid,
                          _image,
                          nameController.text,
                          codeController.text,
                          nameController.text,
                          int.parse(stockController.text),
                          int.parse(priceController.text),
                          categoryItem,
                          base64Encode(_image.readAsBytesSync()));
                    } else {
                      DocumentReference documentTask = FirebaseFirestore
                          .instance
                          .doc('${currentUser.uid}/${nameController.text}');
                      FirebaseFirestore.instance
                          .runTransaction((transaction) async {
                        DocumentSnapshot task =
                            await transaction.get(documentTask);
                        if (task.exists) {
                          StorageReference firebaseStorageRef = FirebaseStorage
                              .instance
                              .ref()
                              .child('$user/${_image.path}');
                          StorageUploadTask uploadTask =
                              firebaseStorageRef.putFile(_image);
                          StorageTaskSnapshot taskSnapshot =
                              await uploadTask.onComplete;
                          taskSnapshot.ref
                              .getDownloadURL()
                              .then((value) => print("done: $value"));
                          await transaction
                              .update(documentTask, <String, dynamic>{
                            'name': nameController.text,
                            'kode': codeController.text,
                            'price': priceController.text,
                            'stock': stockController.text,
                            'category': categoryItem,
                            'img': _image.path
                          });
                          Navigator.of(context)
                              .pushReplacementNamed(MainScreen.id);
                        }
                      });
                    }

                    // if (product == null) {
                    //   product = ItemModel(
                    //       codeController.text,
                    //       nameController.text,
                    //       int.parse(stockController.text),
                    //       int.parse(priceController.text),
                    //       imgString);
                    // } else {
                    //   product.name = nameController.text;
                    //   product.sku = codeController.text;
                    //   product.stock = int.parse(stockController.text);
                    //   product.price = int.parse(priceController.text);
                    //   product.imgProduct = imgString;
                    // }
                    Navigator.pop(context, product);
                  },
                  child: Text(
                    "Simpan",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              widget.isEdit == true
                  ? Container(
                      padding: EdgeInsets.only(top: 8, right: 10, left: 10),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 15,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.red,
                        textColor: Colors.white,
                        onPressed: () {
                          _alertDeleteProduct();
                        },
                        child: Text(
                          "Hapus",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    )
                  : Container(
                      child: null,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
