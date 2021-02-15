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
          Center(child: Text("This is meant to be a home page")),
          SizedBox(height: 20),
          ListTile(
            ,
            onTap: () {
              Navigator.pushNamed(context, '/transaction');
            },
            title: Text("Transaction"),
            tileColor: Colors.red,
          )
            
        ],
      ),
      )
    );
  }
}
