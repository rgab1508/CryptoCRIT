import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:secp256k1/secp256k1.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class PasswordLoginPage extends StatefulWidget {
  @override
  _PasswordLoginPageState createState() => _PasswordLoginPageState();
}

class _PasswordLoginPageState extends State<PasswordLoginPage> {
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool _loadingButton = false;
    final passwordText = TextField(
      minLines: 3,
      maxLines: 3,
      controller: password,
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
          hintText: 'squirrel course desert damage .......',
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          )),
    );

    final submitButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30),
        color: Colors.blue,
        child: Builder(
            builder: (context) => MaterialButton(
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  onPressed: () async {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    setState(() {
                      _loadingButton = true;
                    });
                    var pwd = password.text;
                    if (pwd.isEmpty) {
                      final sb = SnackBar(
                        content: Text("passphrase is empty"),
                      );
                      Scaffold.of(context).showSnackBar(sb);
                    }
                    var pk;
                    var valid = true;
                    try {
                      pk = bip39.mnemonicToEntropy(pwd.trim());
                    } catch (e) {
                      valid = false;
                      setState(() {
                        _loadingButton = false;
                      });
                      final sb = SnackBar(
                        content: Text('Password Invalid.(try again)'),
                      );
                      Scaffold.of(context).showSnackBar(sb);
                    }
                    if (valid) {
                      var privateKey = PrivateKey.fromHex(pk);
                      var publicKey = privateKey.publicKey.toHex();
                      final pref = await SharedPreferences.getInstance();
                      var rollNo = pref.getString('roll_no');
                      final res = await http.get(
                          'https://cryptocrit.herokuapp.com/user?rollno=$rollNo');
                      if (res.statusCode != 200) {
                        print(res.body);
                        final sb = SnackBar(
                          content: Text(res.body),
                        );
                        Scaffold.of(context).showSnackBar(sb);
                        setState(() {
                          _loadingButton = false;
                        });
                      } else {
                        final registeredPublickey =
                            jsonDecode(res.body)['public_key'];
                        print(registeredPublickey);
                        print(publicKey);
                        if (registeredPublickey == publicKey) {
                          final sb = SnackBar(
                            content: Text('Logged In Successfully'),
                          );
                          Scaffold.of(context).showSnackBar(sb);
                          pref.setString('private_key', privateKey.toHex());
                          pref.setString('public_key', publicKey.toString());
                          Navigator.pushReplacementNamed(context, '/home');
                        } else {
                          setState(() {
                            _loadingButton = false;
                          });
                          final sb = SnackBar(
                            content: Text('Password Incorrect.(try again)'),
                          );
                          Scaffold.of(context).showSnackBar(sb);
                        }
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
                )));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Enter PassPhrase",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              child: passwordText,
            ),
            SizedBox(
              height: 30,
            ),
            submitButton
          ],
        ),
      ),
    );
  }
}
