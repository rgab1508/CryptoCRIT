import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceiveCoins extends StatefulWidget {
  @override
  _ReceiveCoinsState createState() => _ReceiveCoinsState();
}

class _ReceiveCoinsState extends State<ReceiveCoins> {
  var qr_data = <String, dynamic>{
    "crit": true,
  };
  var _loading = true;

  Future<void> getPublicKey() async {
    final pref = await SharedPreferences.getInstance();
    qr_data['public_key'] = pref.getString('public_key');
    qr_data['roll_no'] = pref.getString('roll_no');
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getPublicKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Receive coins"),
          centerTitle: true,
          backgroundColor: Color(0xff7e57c2),
          elevation: 0,
        ),
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "QR code",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.network(
                  'https://chart.googleapis.com/chart?chs=500x500&cht=qr&chl=' +
                      jsonEncode(qr_data) +
                      '&choe=UTF-8'),
            ),
          ],
        ));
  }
}
