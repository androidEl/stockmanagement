//import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//import 'package:stockmanagement/model/item_model.dart';
//import 'package:stockmanagement/screen/item_screen_detail.dart';
//
//class Item extends StatefulWidget {
//  final ItemModel _item;
//
//  const Item(this._item);
//
//  @override
//  _ItemState createState() => _ItemState();
//}
//
//class _ItemState extends State<Item> {
//  @override
//  Widget build(BuildContext context) {
//    int stock = widget._item.itemStock;
//    return InkWell(
//      onLongPress: () {},
//      onTap: () => Navigator.push(context,
//          MaterialPageRoute(builder: (context) => ItemDetail(widget._item))),
//      child: Container(
//        padding: EdgeInsets.all(8),
//        child: Row(
//          children: <Widget>[
//            Hero(
//              tag: "avatar_" + widget._item.id.toString(),
//              child: CircleAvatar(
//                radius: 32,
//                backgroundImage: NetworkImage(widget._item.itemAvatar),
//              ),
//            ),
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Container(
//                width: MediaQuery.of(context).size.width / 1.35,
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Text(
//                      widget._item.itemName,
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold, fontSize: 16.0),
//                    ),
//                    Text(
//                      widget._item.itemCode,
//                      style: TextStyle(fontSize: 16.0, color: Colors.grey),
//                    ),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Text(
//                          "Rp." + widget._item.itemPrice.toString(),
//                          style: TextStyle(fontSize: 16.0, color: Colors.grey),
//                        ),
//                        Container(
//                          child: Row(
//                            children: <Widget>[
//                              IconButton(
//                                  icon: Icon(Icons.add),
//                                  onPressed: () {
//                                    setState(() {
//                                      int plus = stock + 1;
//                                      print(plus);
//                                    });
//                                  }),
//                              Text(stock.toString()),
//                              IconButton(
//                                  icon: Icon(Icons.remove), onPressed: () {}),
//                            ],
//                          ),
//                        )
//                      ],
//                    )
//                  ],
//                ),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
