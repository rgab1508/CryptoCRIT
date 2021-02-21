import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();
    String rollNo;

    @override
    void dispose() {
      myController.dispose();
      super.dispose();
    }

    final rollField = TextField(
      controller: myController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      cursorColor: Colors.white,
      obscureText: false,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Roll No.',
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          )),
    );

    final submitButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30),
        color: Colors.blue,
        child: Builder(
          builder: (context) => MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            onPressed: () async {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              rollNo = myController.text;
              if (rollNo.length != 7) {
                var sb = SnackBar(
                  content: Text("Enter a vaild Roll No."),
                );
                Scaffold.of(context).showSnackBar(sb);
              } else {
                //Checking if rollno exists in DB and if exists trying to login
                final res = await http.post(
                  'https://cryptocrit.herokuapp.com/login',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, String>{
                    'rollno': rollNo,
                  }),
                );
                if (res.statusCode != 200) {
                  final sb = SnackBar(
                    content: Text(res.body.toString()),
                  );
                  Scaffold.of(context).showSnackBar(sb);
                } else {
                  final token = jsonDecode(res.body)['token'];
                }
              }
              //Navigator.pushReplacementNamed(context, '/home');
            },
            child: Text(
              "Submit",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));

    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 155.0,
                child: Text(
                  "LOGIN",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
              ),
              SizedBox(height: 45),
              rollField,
              SizedBox(height: 25),
              submitButton,
            ],
          ),
        ),
      ),
    );
  }
}
