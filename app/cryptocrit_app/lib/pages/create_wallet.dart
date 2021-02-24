import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secp256k1/secp256k1.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreateWalletPage extends StatefulWidget {
  @override
  _CreateWalletPageState createState() => _CreateWalletPageState();
}

class _CreateWalletPageState extends State<CreateWalletPage> {
  bool _loading = true;

  Future<void> getKeys() async {
    var privateKey = PrivateKey.generate();
    var publicKey = privateKey.publicKey.toHex();
    final mneonics = bip39.entropyToMnemonic(privateKey.toHex());

    //Showing dialog of the mneonics

    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token') ?? "";

    final res = await http.post('https://cryptocrit.herokuapp.com/create',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{'token': token, 'public_key': publicKey}));
    if (res.statusCode != 200) {
      var sb = SnackBar(
        content: Text(res.body),
      );
      Scaffold.of(context).showSnackBar(sb);
    } else {
      setState(() {
        _loading = false;
      });
      pref.setString('public_key', publicKey);
      pref.setString('private_key', privateKey.toHex());
      final dialog = AlertDialog(
        backgroundColor: Colors.grey[800],
        title: Text("Copy this or Write it down"),
        content: Text(mneonics),
        actions: [
          FlatButton(
            child: Text("Copy"),
            onPressed: () {
              Clipboard.setData(new ClipboardData(text: mneonics));
            },
          ),
          FlatButton(
            child: Text("Okay"),
            onPressed: () {
              Navigator.pop(context, true);
            },
          )
        ],
      );

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Expanded(
              child: dialog,
            );
          });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getKeys();
    });

    //@TODO create public and private keys
  }

  @override
  Widget build(BuildContext context) {
    final nextButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30),
        color: Colors.blue,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width * 0.65,
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Text(
            "Next >>",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              _loading ? "Setting up Wallet" : "Wallet Created.",
              style: TextStyle(fontSize: 30.0, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: _loading ? 40 : 10),
          _loading
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  height: 7,
                  child: LinearProgressIndicator(),
                )
              : SizedBox(
                  height: 1,
                ),
          SizedBox(
            height: 30,
          ),
          _loading
              ? SizedBox(
                  width: 1,
                )
              : nextButton
        ],
      ),
    );
  }
}
