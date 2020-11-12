import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:stockmanagement/controller/crud_controller.dart';

Future uploadImage(
    String imgPath,
    String user,
    File img,
    String nameD,
    String codeP,
    String nameP,
    int stockP,
    int priceP,
    String categoryP,
    String imgP) async {
  String filename = imgPath;
  StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child('$user/$filename');
  StorageUploadTask uploadTask = firebaseStorageRef.putFile(img);
  StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
  taskSnapshot.ref.getDownloadURL().then((value) => print("done: $value"));
  await FirebaseFirestore.instance.collection("$user").doc(nameD).set({
    "kode": codeP,
    "name": nameP,
    "stock": stockP,
    "price": priceP,
    "category": categoryP,
    "img": imgP
  });
}

Future getData() async {
  User currentUser = FirebaseAuth.instance.currentUser;
  var firestore = FirebaseFirestore.instance;
  QuerySnapshot qn = await firestore.collection(currentUser.uid).get();
  return qn.docs;
}

Stream<QuerySnapshot> searchData(String string) async* {
  User currentUser = FirebaseAuth.instance.currentUser;
  var firestore = FirebaseFirestore.instance;
  var _search = firestore
      .collection(currentUser.uid)
      .where('name', isGreaterThanOrEqualTo: string)
      .where('name', isLessThan: string + 'z')
      .snapshots();

  yield* _search;
}

Stream<QuerySnapshot> stream() async* {
  User currentUser = FirebaseAuth.instance.currentUser;
  var firestore = FirebaseFirestore.instance;
  var _stream = firestore.collection(currentUser.uid).snapshots();
  yield* _stream;
}

void updateProduct(String docId, String name, String kode, String category,
    int price, int stock, String img) async {
  var firestore = FirebaseFirestore.instance;
  firestore.collection(currentUser.uid).doc(docId).update({
    "name": name,
    "kode": kode,
    "category": category,
    "price": price,
    "stock": stock,
    "img": img
  }).then((_) => print("success"));
}

Stream<QuerySnapshot> cata_stream(String string) async* {
  User currentUser = FirebaseAuth.instance.currentUser;
  var firestore = FirebaseFirestore.instance;
  var catagories = firestore
      .collection(currentUser.uid)
      .where('categories', isGreaterThanOrEqualTo: string)
      .where('categories', isLessThan: string + 'z')
      .snapshots();

  yield* catagories;
}
