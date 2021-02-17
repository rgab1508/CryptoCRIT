import 'package:flutter/material.dart';

class HomeTransaction extends StatefulWidget {
  @override
  _HomeTransactionState createState() => _HomeTransactionState();
}

class _HomeTransactionState extends State<HomeTransaction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
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
            child: Text(
              "Send coins",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0
              ),
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
          )
        ],
      )
    );
  }
}
