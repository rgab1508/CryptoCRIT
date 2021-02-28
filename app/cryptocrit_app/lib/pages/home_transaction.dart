import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeTransaction extends StatefulWidget {
  @override
  _HomeTransactionState createState() => _HomeTransactionState();
}

class _HomeTransactionState extends State<HomeTransaction> {
  var balance = "...";

  Future<void> getBalance() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final res =
        await http.get('https://cryptocrit.herokuapp.com/balance?token=$token');
    if (res.statusCode != 200) {
      print("Something went Wrong......");
    } else {
      if (this.mounted) {
        setState(() {
          balance = jsonDecode(res.body)['balance'].toString();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getBalance();
  }

  @override
  Widget build(BuildContext context) {
    getBalance();
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                height: 95,
                alignment: Alignment.topLeft,
                child: Text(
                  "Balance : $balance CC",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: RawMaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/transactions');
                },
                elevation: 5.0,
                fillColor: Colors.blue,
                child: Icon(
                  Icons.arrow_upward,
                  size: 70.0,
                ),
                padding: EdgeInsets.all(20.0),
                shape: CircleBorder(),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: AutoSizeText(
                "Send coins",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
            SizedBox(height: 70),
            Align(
              alignment: Alignment.center,
              child: RawMaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/receive_coins');
                },
                elevation: 5.0,
                fillColor: Colors.lightGreenAccent,
                child: Icon(
                  Icons.arrow_downward,
                  size: 70.0,
                ),
                padding: EdgeInsets.all(20.0),
                shape: CircleBorder(),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Receive coins",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ));
  }
}
