import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:stockmanagement/controller/ads_controller.dart';

import 'package:stockmanagement/controller/auth.dart';

import 'package:stockmanagement/onboard&login/onboarding_model.dart';
import 'package:stockmanagement/onboard&login/onboarding_widget.dart';
import 'package:stockmanagement/screen/main_screen.dart';

class OnboardingScreen extends StatefulWidget {
  static String id = "onboarding";
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  final pages = [
    OnBoardingModel(
        title: 'Manage your product',
        desc: 'Easily manage your item',
        titleColor: Colors.black,
        descColor: const Color(0xFF929794),
        imgPath: "assets/images/395.jpg"),
    OnBoardingModel(
        title: "Real-time database",
        desc: "Access data in everywhere and anytime",
        titleColor: Colors.black,
        descColor: const Color(0xFF929794),
        imgPath: "assets/images/395.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: OnBoardingWidget(
          pages: pages,
          bgColor: Colors.white,
          themeColor: const Color(0xFFF4269),
          skipClicked: (value) {
            print(value);
            _globalKey.currentState
                .showSnackBar(SnackBar(content: Text("Skip clicked")));
          },
          loginClicked: () {
            signInAcc().then((User user) {
              Navigator.pushReplacementNamed(context, MainScreen.id);
            }).catchError((e) => print("Error woy $e"));
          }),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}
