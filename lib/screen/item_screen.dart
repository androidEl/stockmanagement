import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stockmanagement/controller/ads_controller.dart';
import 'package:stockmanagement/controller/crud_controller.dart';
import 'package:stockmanagement/database/crud.dart';
import 'package:stockmanagement/database/firebaseDb.dart';
import 'package:stockmanagement/model/item_model.dart';
import 'package:stockmanagement/screen/add_item_screen.dart';
import 'package:stockmanagement/screen/item_screen_detail.dart';

class ItemScreen extends StatefulWidget {
  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  CRUD dbHelper = CRUD();
  Future<List<ItemModel>> future;
  String searchTxt = '';

  TextEditingController stockController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();

  var kColor = [
    Color(0xFFEF7A85),
    Color(0xFFFF90B3),
    Color(0xFFFFC2E2),
    Color(0xFFB892FF),
    Color(0xFFF651FF),
    Color(0xFFB822FF),
    Color(0xFFB892FF)
  ];

  TextEditingController searchController = new TextEditingController();
  // BannerAd _bannerAd;
  //
  // void _loadBannerAd() {
  //   _bannerAd
  //     ..load()
  //     ..show(anchorType: AnchorType.top);
  // }

  @override
  void initState() {
    updateListView();
    // _bannerAd =
    //     BannerAd(adUnitId: AdsManager.bannerAdUnitId, size: AdSize.banner);
    // _loadBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _bannerAd?.dispose();
  }

  void updateListView() {
    setState(() {
      future = dbHelper.getProductList();
      getData();
      stream();
    });
  }

  Future<ItemModel> navigateToEntryForm(
      BuildContext context, ItemModel product) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return AddItemScreen(false, null, null, null, null, null, null, null);
    }));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            Container(
              height: 0.29.wp,
              width: ScreenUtil.screenWidth,
              color: Colors.blueAccent,
            ),
            Container(
              margin: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: TextField(
                style: TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  hintText: "Search Product",
                  contentPadding: EdgeInsets.only(left: 10.w),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    searchTxt = value;
                  });
                },
              ),
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(top: 110.h, left: 550.w, right: 20.w),
                height: 0.1.wp,
                width: 0.13.hp,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      'Filter',
                      style: TextStyle(
                          fontSize: ScreenUtil()
                              .setSp(32, allowFontScalingSelf: true)),
                    ),
                    Image.asset("assets/images/filter_ico.png")
                  ],
                ),
              ),
              onTap: () {},
            ),
            Container(
              padding: EdgeInsets.only(top: ScreenUtil().setWidth(220)),
              child: productStreams(
                kColor: kColor,
                searchKey: searchTxt,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              // createRecord();
              var product = await navigateToEntryForm(context, null);
              if (product != null) {
                int result = await dbHelper.insert(product);
                if (result > 0) {
                  updateListView();
                }
              }
            }),
      ),
    );
  }
}

class productStreams extends StatelessWidget {
  const productStreams({
    Key key,
    @required this.kColor,
    this.searchKey,
  }) : super(key: key);

  final List<Color> kColor;
  final String searchKey;

  @override
  Widget build(BuildContext context) {
    return buidlList();
  }

  StreamBuilder<QuerySnapshot> buidlList() {
    return StreamBuilder(
        stream: (searchKey != null || searchKey != "")
            ? searchData(searchKey)
            : stream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text("Error"),
            );
          }
          return ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: snapshot.data.docs
                .map((e) => AwesomeListItem(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return AddItemScreen(
                              true,
                              e.get('name'),
                              e.get('name'),
                              e.get('kode'),
                              e.get('stock'),
                              e.get('price'),
                              e.get('category'),
                              e.get('img'));
                        }));
                      },
                      title: e.get('name'),
                      content:
                          "${e.get('kode')} (${e.get('stock')}) Rp.${e.get('price')}\n${e.get('category')}",
                      image: e.get('img'),
                      color: e.get('stock') == "0"
                          ? Colors.black
                          : kColor[new Random().nextInt(5)],
                    ))
                .toList(),
          );
        });
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height / 4.75);
    p.lineTo(0.0, size.height / 3.75);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class AwesomeListItem extends StatefulWidget {
  String title;
  String content;
  Color color;
  String image;
  Function onTap;
  Function onLongTap;

  AwesomeListItem(
      {this.title,
      this.content,
      this.color,
      this.image,
      this.onTap,
      this.onLongTap});

  @override
  _AwesomeListItemState createState() => new _AwesomeListItemState();
}

class _AwesomeListItemState extends State<AwesomeListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongTap,
      child: new Row(
        children: <Widget>[
          new Container(width: 10.0, height: 190.0, color: widget.color),
          new Expanded(
            child: new Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    widget.title,
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: new Text(
                      widget.content,
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          new Container(
            height: 150.0,
            width: 150.0,
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                new Transform.translate(
                  offset: new Offset(50.0, 0.0),
                  child: new Container(
                    height: 100.0,
                    width: 100.0,
                    color: widget.color,
                  ),
                ),
                new Transform.translate(
                  offset: Offset(10.0, 20.0),
                  child: new Card(
                    elevation: 20.0,
                    child: new Container(
                      height: 120.0,
                      width: 120.0,
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 10.0,
                              color: Colors.white,
                              style: BorderStyle.solid),
                          image: DecorationImage(
                              image: MemoryImage(base64Decode(widget.image)))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
