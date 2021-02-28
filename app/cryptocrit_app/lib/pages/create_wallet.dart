import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:cryptocrit_app/utils/rip39.dart' as rip39;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convert/convert.dart';

class CreateWalletPage extends StatefulWidget {
  @override
  _CreateWalletPageState createState() => _CreateWalletPageState();
}

class _CreateWalletPageState extends State<CreateWalletPage> {
  bool _loading = true;

  Future<void> getKeys() async {
    var privateKey = EOSPrivateKey.fromRandom();
    var publicKey = privateKey.toEOSPublicKey();
    print(privateKey.toString());
    final mnemonics =
        rip39.entropyToMnemonic(hex.encode(utf8.encode(privateKey.toString())));

    //Showing dialog of the mneonics

    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token') ?? "";

    final res = await http.post('https://cryptocrit.herokuapp.com/create',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'token': token,
          'public_key': publicKey.toString()
        }));
    if (res.statusCode != 200) {
      // var sb = SnackBar(
      //   content: Text(res.body),
      // );
      // Scaffold.of(context).showSnackBar(sb);
      print(res.body);
    } else {
      setState(() {
        _loading = false;
      });
      pref.setString('public_key', publicKey.toString());
      pref.setString('private_key', privateKey.toString());
      final dialogAndroid = AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          "Copy, write or screenshot",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        content: Text(
          mnemonics,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          FlatButton(
            child: Text("Copy"),
            onPressed: () {
              Clipboard.setData(new ClipboardData(text: mnemonics));
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

      final dialogIos = CupertinoAlertDialog(
        title: Text("Copy, write or Screenshot"),
        content: Text(
          privateKey.toString(),
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text("COPY"),
            onPressed: () {
              Clipboard.setData(new ClipboardData(text: mnemonics));
            },
          ),
          CupertinoDialogAction(
            child: Text("DONE"),
            onPressed: () {
              Navigator.pop(context, true);
            },
          )
        ],
      );

      showDialog(
          context: context,
          builder: (BuildContext context) {
            if (Platform.isAndroid) {
              return Expanded(
                child: dialogAndroid,
              );
            } else if (Platform.isIOS) {
              return Expanded(child: dialogIos);
            }
          });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getKeys();
    });
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
