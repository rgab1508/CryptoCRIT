import 'package:flutter/material.dart';

class HomeHistory extends StatefulWidget {
  @override
  _HomeHistoryState createState() => _HomeHistoryState();
}

class _HomeHistoryState extends State<HomeHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [ 
            Container(
              height: 120,
              alignment: Alignment.center,
              child: Text(
                "Transaction history",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ]
        ),
      )

    );
  }
}
