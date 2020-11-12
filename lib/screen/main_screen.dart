import 'package:flutter/material.dart';
import 'package:stockmanagement/database/crud.dart';
import 'package:stockmanagement/model/item_model.dart';
import 'package:stockmanagement/screen/add_item_screen.dart';
import 'package:stockmanagement/screen/item_screen.dart';
import 'package:stockmanagement/screen/profile_screen.dart';

class MainScreen extends StatefulWidget {
  static String id = 'MainScreen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedTabIndex = 0;
  CRUD dbHelper = CRUD();
  Future<List<ItemModel>> future;

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  void updateListView() {
    setState(() {
      future = dbHelper.getProductList();
    });
  }

  @override
  void initState() {
    updateListView();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _listPage = <Widget>[ItemScreen(), ProfilScreen()];

    final _bottomNavBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.add),
        title: Text('Add Item'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.store),
        title: Text('Report'),
      ),
    ];

    final _bottomNavBar = BottomNavigationBar(
      items: _bottomNavBarItems,
      currentIndex: _selectedTabIndex,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      onTap: _onNavBarTapped,
    );

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: _listPage[_selectedTabIndex],
        bottomNavigationBar: _bottomNavBar);
  }
}
