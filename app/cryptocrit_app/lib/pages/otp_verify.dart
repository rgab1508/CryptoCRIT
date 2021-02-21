import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

class OTPverifyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final otpTextController = TextEditingController();

    final otpTextBox = TextField(
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
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'OTP',
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
            final otp = otpTextController.text;
            //check if otp is valid
            final url = "https://cryptocrit.herokuapp.com/verify";
            final token = ModalRoute.of(context).settings.arguments;
            var sb = SnackBar(
              content: Text(token),
            );
            Scaffold.of(context).showSnackBar(sb);

            final res = await http.post(url,
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, String>{'token': token, 'otp': otp}));
          },
        ),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.grey[800],
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
