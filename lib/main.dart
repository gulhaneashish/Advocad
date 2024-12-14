
import 'package:advocad/advocad.dart';
import 'package:advocad/login.dart';
import 'package:advocad/main.dart';
import 'package:advocad/register.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyLogin(),
    routes: {
      'register': (context) => MyRegister(),
      'login': (context) => MyLogin(),
      'AdvocadApp':(context) => AdvocadApp(),
    },
  ));
}

