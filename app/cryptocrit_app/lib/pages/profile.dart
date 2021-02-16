import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 70,
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: Text(
                  "Balance : ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "NAME",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Insert name here",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              SizedBox(height: 25),
              Text(
                "ROLL NO.",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Insert roll no.",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
