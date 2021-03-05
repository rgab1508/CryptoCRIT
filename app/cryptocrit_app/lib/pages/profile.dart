import 'dart:convert';
//import 'dart:html';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cryptocrit_app/utils/rip39.dart' as rip39;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String email = "";
  String rollNo = "";
  String balance = "...";
  String privateKey;
  var avatar;

  Future<void> getInfo() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      rollNo = pref.getString('roll_no') ?? "";
      email = pref.getString('email') ?? "";
      avatar = pref.getString('avatar');
      privateKey = pref.getString('private_key');
      print(avatar);
    });
    final token = pref.getString('token');
    final res =
        await http.get('https://cryptocrit.herokuapp.com/balance?token=$token');
    if (res.statusCode != 200) {
      print("Something went Wrong......");
    } else {
      setState(() {
        balance = jsonDecode(res.body)['balance'].toString() ?? "...";
      });
    }
    print(rollNo);
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    final copyButton = Material(
        color: Colors.black,
        child: TextButton(
          onPressed: () {
            var mnemonics = rip39.entropyToMnemonic(privateKey);
            Clipboard.setData(new ClipboardData(text: mnemonics));
            var sb = SnackBar(
              content: Text("Copied to ClipBoard"),
            );
            Scaffold.of(context).showSnackBar(sb);
          },
          child: Text(
            "COPY PASSPHRASE",
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ));

    final _platformDBA = AlertDialog(
      title: Text("LOGOUT"),
      content: Text("Are you sure to logout ?"),
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      contentTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      actions: [
        FlatButton(
            onPressed: () async {
              final pref = await SharedPreferences.getInstance();
              final token = pref.getString('token');
              final res =
                  await http.post('https://cryptocrit.herokuapp.com/logout',
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(<String, String>{
                        'token': token,
                      }));
              if (res.statusCode != 200) {
                final sb = SnackBar(
                  content: Text('Something went wrong..'),
                );
                print(res.body);
                Scaffold.of(context).showSnackBar(sb);
              } else {
                await pref.clear();
                SystemNavigator.pop();
              }
              //SystemChannels.platform.invokeMethod('SystemNavigator.pop()');
            },
            child: Text(
              "Yes",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )),
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "No",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ))
      ],
    );

    final _platformDBI = CupertinoAlertDialog(
      title: new Text(
        "LOGOUT",
        style: TextStyle(fontSize: 20),
      ),
      content: new Text(
        "Are you sure to logout",
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text("Yes"),
          onPressed: () async {
            final pref = await SharedPreferences.getInstance();
            await pref.clear();
            Navigator.pop(context);
            Navigator.popAndPushNamed(context, '/login');
            //Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: Text("No"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              if (Platform.isAndroid) {
                                return _platformDBA;
                              } else if (Platform.isIOS) {
                                return _platformDBI;
                              }
                            });
                      },
                      child: Text("LOGOUT"),
                    ),
                  ),
                ),
                Flexible(child: SizedBox(height: 50), flex: 0),
                Flexible(
                  flex: 4,
                  child: Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      child: avatar == null
                          ? null
                          : SvgPicture.network(
                              avatar,
                              fit: BoxFit.fill,
                              semanticsLabel: 'Avatar',
                              placeholderBuilder: (BuildContext context) =>
                                  Container(
                                      padding: const EdgeInsets.all(30.0),
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                      )),
                            ),
                      backgroundColor: Colors.white,
                      radius: 80,
                    ),
                  ),
                ),
                Flexible(child: SizedBox(height: 30), flex: 0),
                Flexible(
                  child: Divider(
                    height: 20,
                    color: Colors.grey[700],
                  ),
                  flex: 1,
                ),
                Flexible(
                  flex: 1,
                  child: Center(
                    child: AutoSizeText(
                      "Balance : $balance CC",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                        color: Colors.white,
                      ),
                      minFontSize: 25,
                    ),
                  ),
                ),
                Flexible(child: SizedBox(height: 30), flex: 0),
                Flexible(
                  flex: 1,
                  child: AutoSizeText(
                    "EMAIL:",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 20,
                    ),
                    minFontSize: 15,
                  ),
                ),
                Flexible(child: SizedBox(height: 15), flex: 0),
                Flexible(
                  flex: 1,
                  child: AutoSizeText(
                    email,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    minFontSize: 25,
                  ),
                ),
                Flexible(child: SizedBox(height: 25), flex: 0),
                Flexible(
                  flex: 1,
                  child: AutoSizeText(
                    "ROLL NO:",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 20,
                    ),
                  ),
                ),
                Flexible(child: SizedBox(height: 15), flex: 0),
                Flexible(
                  flex: 1,
                  child: AutoSizeText(
                    rollNo,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    minFontSize: 25,
                  ),
                ),
                Flexible(
                  child: Divider(
                    height: 20,
                    color: Colors.grey[700],
                  ),
                  flex: 1,
                ),
                copyButton
              ],
            ),
          ),
        ),
      ),
    );
  }
}
