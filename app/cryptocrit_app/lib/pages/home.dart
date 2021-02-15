import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
      child: Column(
        children: [
          SizedBox(height: 20),
          Center(child: Text("Profile details go here")),
          SizedBox(height: 20),
          Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                "Transactions",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ) ,
              ),
              tileColor: Colors.red,
              onTap:() {
                Navigator.pushNamed(context, '/transaction');
              },
            ),
          ),
          Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                "Blockchain",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ) ,
              ),
              tileColor: Colors.blue,
              onTap:() {
                Navigator.pushNamed(context, '/blockchain');
              },
            ),
          ),
          Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                "History",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ) ,
              ),
              tileColor: Colors.green,
              onTap:() {
                Navigator.pushNamed(context, '/history');
              },
            ),
          )
        ],
      ),
      )
    );
  }
}
