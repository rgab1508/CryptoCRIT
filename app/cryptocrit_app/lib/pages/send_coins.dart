import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  final myController = TextEditingController();
  String rollNo;
  String publicKey;
  bool _loadingButton = false;

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print('Transaction initState run');
    setState(() {
      _loadingButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final rollField = TextField(
      controller: myController,
      autofocus: false,
      cursorColor: Colors.white,
      obscureText: false,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
          fillColor: Colors.grey[900],
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Enter Roll No.",
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
                width: 4,
              ))),
    );

    final submitButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30),
        color: Color(0xFF7e57c2),
        child: Builder(
          builder: (context) => MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            onPressed: () async {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              setState(() {
                _loadingButton = true;
              });
              rollNo = myController.text;
              var validRollNo = true;
              if (rollNo.length < 7) {
                validRollNo = false;
                setState(() {
                  _loadingButton = false;
                });
                final sb = SnackBar(
                  content: Text("Enter a Valid Roll No."),
                );
                Scaffold.of(context).showSnackBar(sb);
              }
              if (validRollNo) {
                final res = await http.get(
                    'https://cryptocrit.herokuapp.com/user?rollno=$rollNo');
                if (res.statusCode != 200) {
                  final sb = SnackBar(
                    content: Text(res.body),
                  );
                  Scaffold.of(context).showSnackBar(sb);
                  setState(() {
                    _loadingButton = false;
                  });
                } else {
                  publicKey = jsonDecode(res.body)['public_key'];
                  Navigator.pushNamed(context, '/send_coins_a',
                      arguments: jsonEncode(<String, String>{
                        'roll_no': rollNo,
                        'public_key': publicKey
                      }));
                }
              }
            },
            child: _loadingButton
                ? CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    strokeWidth: 2,
                  )
                : AutoSizeText(
                    "Submit",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                    overflowReplacement: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 22,
                    ),
                    maxLines: 1,
                  ),
          ),
        ));

    final snackBar101 = SnackBar(content: Text("This feature is not available now."));
    final qrButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30),
        color: Color(0xff7e57c2),
        child: Builder(
          builder: (context) => MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            onPressed: () async {
              if (Platform.isAndroid || Platform.isIOS) {
                Navigator.pushNamed(context, '/qr_scan');
              }
              else{
                ScaffoldMessenger.of(context).showSnackBar(snackBar101);
              }
            },
            child: AutoSizeText(
              "Scan QR code",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
              overflowReplacement: Icon(
                Icons.qr_code,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ));

    double height1 = MediaQuery.of(context).size.height;
    //print('Transaction build run');
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Transaction'),
        centerTitle: true,
        backgroundColor: Color(0xff7e57c2),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(13.0),
          child: Column(
            children: [
              Flexible(
                flex: 4,
                child: SizedBox(
                  height: height1 * 0.35,
                  child: Center(
                    child: AutoSizeText(
                      "Send CritCoins",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                      minFontSize: 25,
                    ),
                  ),
                ),
              ),
              Flexible(flex: 2, child: rollField),
              SizedBox(height: height1 * 0.015),
              Flexible(child: submitButton, flex: 2),
              Flexible(child: SizedBox(height: height1 * 0.020), flex: 1),
              Flexible(
                flex: 1,
                child: AutoSizeText(
                  "OR",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  minFontSize: 10,
                ),
              ),
              SizedBox(height: height1 * 0.020),
              Flexible(child: qrButton, flex: 2)
            ],
          ),
        ),
      ),
    );
  }
}
