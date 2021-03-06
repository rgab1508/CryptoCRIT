import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _loadingButton = false;

  final myController = TextEditingController();
  String rollNo;

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rollField = TextField(
      autofocus: true,
      controller: myController,
      cursorColor: Colors.white,
      obscureText: false,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
          fillColor: Colors.grey[850],
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Roll No.',
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide(color: Color(0xff7e57c2), width: 3))),
    );

    final submitButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30),
        color: Color(0xff7e57c2),
        child: Builder(
          builder: (context) => MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            onPressed: () async {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              rollNo = myController.text;
              setState(() {
                _loadingButton = true;
              });
              if (rollNo.length < 5) {
                var sb = SnackBar(
                  content: Text("Enter a vaild Roll No."),
                );
                Scaffold.of(context).showSnackBar(sb);
                setState(() {
                  _loadingButton = false;
                });
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
                  setState(() {
                    _loadingButton = false;
                  });
                  final sb = SnackBar(
                    content: Text(res.body.toString()),
                  );
                  Scaffold.of(context).showSnackBar(sb);
                } else {
                  final data = jsonDecode(res.body);
                  final token = data['token'];
                  final email = data['email'];
                  Navigator.pushReplacementNamed(context, '/otp_verify',
                      arguments: jsonEncode(<String, String>{
                        'token': token,
                        'rollNo': rollNo,
                        'email': email
                      }));
                }
              }
              //Navigator.pushReplacementNamed(context, '/home');
            },
            child: _loadingButton
                ? CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    strokeWidth: 2,
                  )
                : Text(
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
      backgroundColor: Colors.black,
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
