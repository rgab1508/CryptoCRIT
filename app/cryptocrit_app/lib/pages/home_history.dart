import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeHistory extends StatefulWidget {
  @override
  _HomeHistoryState createState() => _HomeHistoryState();
}

class _HomeHistoryState extends State<HomeHistory> {
  List transactions = [];
  bool _loading = true;

  Future<void> getTransactions() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final res =
        await http.get('https://cryptocrit.herokuapp.com/history?token=$token');
    if (res.statusCode != 200) {
      final sb = SnackBar(
        content: Text(res.body),
      );
      ScaffoldMessenger.of(context).showSnackBar(sb);
    } else {
      if (this.mounted) {
        setState(() {
          transactions = jsonDecode(res.body);
          transactions = transactions.reversed.toList();
          _loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _loading
          ? Container(
              child: Center(
              child: CircularProgressIndicator(),
            ))
          : Container(
              child: Column(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 30),
                      child: Text(
                        "History",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      )),
                ),
                Flexible(
                  flex: 4,
                  child: Container(
                    height: 555,
                    child: ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) => TransactionTile(
                              type: transactions[index]["type"],
                              amount: transactions[index]['amount'],
                              rollNo: transactions[index]["type"] == "send"
                                  ? transactions[index]['to_roll_no']
                                  : transactions[index]['from_roll_no'],
                              address: transactions[index]["type"] == "send"
                                  ? transactions[index]['to_address']
                                  : transactions[index]['from_address'],
                              timestamp: transactions[index]['timestamp'],
                            )),
                  ),
                )
              ],
            )),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final amount;
  final rollNo;
  final address;
  final timestamp;
  final type;

  TransactionTile(
      {this.amount, this.rollNo, this.address, this.timestamp, this.type});

  String truncate(String s, int len) {
    return s.substring(0, len) + "....";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(6.0, 1.5, 6.0, 1.5),
          child: ListTile(
            onLongPress: () {
              Clipboard.setData(new ClipboardData(text: address));
            },
            title: Text(
              amount.toString() +
                  " CC " +
                  (type == "send" ? "-> " : "<- ") +
                  rollNo,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              type == "send"
                  ? "To : " +
                      truncate(address, 20) +
                      "\nTime: " +
                      DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp))
                          .toString()
                          .substring(0, 19)
                  : "From : " +
                      truncate(address, 18) +
                      "\nTime: " +
                      DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp))
                          .toString()
                          .substring(0, 19),
              style: TextStyle(color: Colors.white),
            ),
            tileColor: type == "send" ? Colors.grey[900] : Colors.grey[900],
            leading: type == "send"
                ? Icon(
                    Icons.arrow_forward_outlined,
                    size: 25,
                    color: Colors.blue,
                  )
                : Icon(Icons.arrow_back_outlined,
                    size: 25, color: Colors.green),
            trailing: GestureDetector(
              onTap: () async {
                Navigator.pushNamed(context, '/send_coins_a',
                    arguments: jsonEncode(<String, String>{
                      'roll_no': rollNo,
                      'public_key': address,
                      'from_history': "true"
                    }));
              },
              child: Icon(
                Icons.send,
                size: 25,
                color: Colors.white,
              ),
            ),
          )),
    );
  }
}
