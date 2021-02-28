import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class OTPVerifyPage extends StatefulWidget {
  @override
  _OTPverifyPageState createState() => _OTPverifyPageState();
}

class _OTPverifyPageState extends State<OTPVerifyPage> {
  bool _loadingButton = false;
  var rollNo;
  var email;

  @override
  Widget build(BuildContext context) {
    final otpTextController = TextEditingController();

    final otpTextBox = TextField(
      autofocus: true,
      controller: otpTextController,
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
          fillColor: Colors.grey[850],
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'OTP',
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide(
                color: Color(0xff7e57c2),
                width: 03,
              ))),
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
            setState(() {
              _loadingButton = true;
            });
            final otp = otpTextController.text;
            //check if otp is valid
            final url = "https://cryptocrit.herokuapp.com/verify";
            final data = jsonDecode(ModalRoute.of(context).settings.arguments);
            final token = data['token'];
            rollNo = data['rollNo'];
            email = data['email'];

            final res = await http.post(url,
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, String>{'token': token, 'otp': otp}));

            if (res.statusCode != 200) {
              var sb = SnackBar(
                content: Text(res.body),
              );
              Scaffold.of(context).showSnackBar(sb);
              setState(() {
                _loadingButton = false;
              });
            } else {
              var data = jsonDecode(res.body);
              var finalToken = data['token'];
              var isNew = data['isNew'];
              final pref = await SharedPreferences.getInstance();
              pref.setString('token', finalToken.toString());
              pref.setString('roll_no', rollNo.toString());
              pref.setString('email', email);
              if (isNew) {
                Navigator.pushNamed(context, '/create_wallet');
              } else {
                Navigator.pushReplacementNamed(context, '/password_login');
                print("Existing User");
              }
            }
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
      ),
    );

    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Verify OTP",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w100),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  "Enter the OTP received from <email>",
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
              SizedBox(
                height: 45,
              ),
              otpTextBox,
              SizedBox(
                height: 25,
              ),
              submitButton
            ],
          ),
        )));
  }
}
