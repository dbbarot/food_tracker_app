import 'package:flutter/material.dart';
import 'login_signup_page.dart';
import 'package:food_tracker_app/authentication.dart';
import 'package:food_tracker_app/root_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Food Tracker App',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          backgroundColor: Colors.black,
          primarySwatch: Colors.green,
        ),
        home: new RootPage(auth: new Auth()
        ));
  }
}
