import 'package:central_borssa/presentation/Main/HomeOfApp.dart';
import 'package:central_borssa/presentation/Main/Loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splashpage extends StatefulWidget {
  late String token;
  splashpage({
    Key? key,
    required this.token,
  }) : super(key: key);
  SplashPage_page createState() => SplashPage_page();
}

// ignore: camel_case_types
class SplashPage_page extends State<splashpage> {
  String? token = "";
  late Future? temp;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String?> value() async {
    final SharedPreferences prefs = await _prefs;
    token = prefs.getString('token').toString();
    return token;
  }

  @override
  initState() {
    Firebase.initializeApp();
    print('firebase');
    token = widget.token;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: token != null ? Loginpage() : HomeOfApp(),
    );
  }
}
