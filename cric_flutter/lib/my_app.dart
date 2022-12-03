import 'package:cric_flutter/Authentication/login_page.dart';
import 'package:cric_flutter/Pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      home: firebaseUser == null ? LoginPage() : HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
