import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stockmanagement/model/item_model.dart';
import 'package:stockmanagement/screen/main_screen.dart';

class ItemDetail extends StatelessWidget {
  final ItemModel _item;

  const ItemDetail(this._item);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_item.name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, MainScreen.id);
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacementNamed(context, MainScreen.id);
          return Future.value(false);
        },
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                child: Hero(
                  tag: "avatar_" + _item.id.toString(),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage:
                        MemoryImage(base64Decode(_item.imgProduct)),
                  ),
                ),
              ),
              Text(
                _item.name,
                style: TextStyle(fontSize: 22),
              )
            ],
          ),
        ),
      ),
    );
  }
}
