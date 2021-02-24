import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  @override
  Widget build(BuildContext context) {



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
                            return AlertDialog(
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
                                    onPressed: () {
                                     //SystemChannels.platform.invokeMethod('SystemNavigator.pop()');
                                     SystemNavigator.pop();
                                    },
                                    child: Text(
                                        "Yes",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                ),
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
                                    )
                                )
                              ],
                            );
                          }
                        );
                      },
                      child: Text("LOGOUT"),
                    ),
                  ),
                ),
                Flexible(child: SizedBox(height:50),flex:0),
                Flexible(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 80,
                    ),
                  ),
                ),
                Flexible(child: SizedBox(height: 30),flex:0 ),
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
                      "Balance : ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                        color: Colors.white,
                      ),
                      minFontSize: 25,
                    ),
                  ),
                ),
                Flexible(child: SizedBox(height: 30),flex: 0),
                Flexible(
                  flex: 1,
                  child: AutoSizeText(
                    "NAME",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 20,
                    ),
                    minFontSize: 15,
                  ),
                ),
                Flexible(child: SizedBox(height: 15),flex: 0),
                Flexible(
                  flex: 1,
                  child: AutoSizeText(
                    "Insert name here",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                    minFontSize: 25,
                  ),
                ),
                Flexible(child: SizedBox(height: 25),flex: 0),
                Flexible(
                  flex: 1,
                  child: AutoSizeText(
                    "ROLL NO.",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 20,
                    ),
                  ),
                ),
                Flexible(child: SizedBox(height: 15),flex: 0),
                Flexible(
                  flex: 1,
                  child: AutoSizeText(
                    "Insert roll no.",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                    minFontSize: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
