import 'package:flutter/material.dart';
import 'package:cryptocrit_app/pages/loading.dart';
import 'package:cryptocrit_app/pages/transaction.dart';
import 'package:cryptocrit_app/pages/home.dart';
import 'package:cryptocrit_app/pages/login.dart';
import 'package:cryptocrit_app/pages/blockchain.dart';
import 'package:cryptocrit_app/pages/new_user.dart';

//Main file
void main() => runApp(MaterialApp(
  initialRoute: '/home',
  routes: {
    '/' : (context) => Loading(),
    '/login' : (context) => Login(),
    '/home' : (context) => Home(),
    '/blockchain' : (context) => Blockchain(),
    '/transaction' : (context) => Transactions(),
    '/new_user' : (context) => NewUserLogin(),
  },
));