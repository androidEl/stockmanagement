import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stockmanagement/screen/add_item_screen.dart';
import 'package:stockmanagement/screen/main_screen.dart';
import 'package:stockmanagement/screen/onboarding_screen.dart';

User _auth = FirebaseAuth.instance.currentUser;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print(_auth);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
      initialRoute: _auth != null ? MainScreen.id : OnboardingScreen.id,
      routes: {
        MainScreen.id: (context) => MainScreen(),
        AddItemScreen.id: (context) =>
            AddItemScreen(false, null, null, null, null, null, null, null),
        OnboardingScreen.id: (context) => OnboardingScreen()
      },
    );
  }
}
