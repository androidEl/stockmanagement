import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final databaseReferences = FirebaseFirestore.instance;
DocumentReference ref;
User currentUser = FirebaseAuth.instance.currentUser;

void createRecord() async {
  await databaseReferences
      .collection(currentUser.uid)
      .doc("1")
      .set({'title': 'Mastering', 'desc': 'programming dart'});
  ref = await databaseReferences
      .collection(currentUser.uid)
      .add({'title': 'flutter action', 'desc': 'Complete program'});
}
