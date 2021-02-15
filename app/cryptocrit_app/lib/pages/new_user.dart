import 'package:flutter/material.dart';

class NewUserLogin extends StatefulWidget {
  @override
  _NewUserLoginState createState() => _NewUserLoginState();
}

class _NewUserLoginState extends State<NewUserLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New user registration"),
        centerTitle: true,
        backgroundColor: Colors.lightGreenAccent,
      ),
    );
  }
}
