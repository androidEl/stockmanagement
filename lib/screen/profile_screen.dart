import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:stockmanagement/controller/auth.dart';
import 'package:stockmanagement/screen/onboarding_screen.dart';

class ProfilScreen extends StatelessWidget {
  User user = FirebaseAuth.instance.currentUser;
  Future<bool> _logoutbtn(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: user != null ? new Text("${user.displayName}") : Text(""),
            content: new Text("Do you want log out ?"),
            actions: <Widget>[
              new GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("No"),
              ),
              SizedBox(
                width: 10,
              ),
              new GestureDetector(
                onTap: () {
                  signOutUser();
                  Navigator.of(context)
                      .pushReplacementNamed(OnboardingScreen.id);
                },
                child: Text("yes"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              user != null ? new Text("${user.displayName}") : Text(""),
              RaisedButton(
                  child: Text("log out"),
                  onPressed: () {
                    _logoutbtn(context);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
