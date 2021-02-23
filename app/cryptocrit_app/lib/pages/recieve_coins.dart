import 'package:flutter/material.dart';


class ReceiveCoins extends StatefulWidget {
  @override
  _ReceiveCoinsState createState() => _ReceiveCoinsState();
}

class _ReceiveCoinsState extends State<ReceiveCoins> {

  String publicKey = 'This is a QR';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receive coins"),
        centerTitle: true,
        backgroundColor: Colors.grey[800],
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.network('https://chart.googleapis.com/chart?chs=500x500&cht=qr&chl=${publicKey}&choe=UTF-8'),
          ),
        ],
      )
    );
  }
}
