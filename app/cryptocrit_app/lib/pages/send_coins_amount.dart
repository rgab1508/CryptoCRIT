import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cryptography/cryptography.dart' as cg;
import 'package:convert/convert.dart';

import 'package:cryptocrit_app/models/transaction_model.dart';

class SendAmountTransactions extends StatefulWidget {
  @override
  _SendAmountTransactionsState createState() => _SendAmountTransactionsState();
}

class _SendAmountTransactionsState extends State<SendAmountTransactions> {
  final trController = TextEditingController();
  var token;
  var rollNo;
  var privateKey;
  var publicKey;
  var recipientPublicKey;
  String coins;
  var fromHistory;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final data = jsonDecode(ModalRoute.of(context).settings.arguments);
      rollNo = data['roll_no'];
      recipientPublicKey = data['public_key'];
      fromHistory = data['from_history'];
      final pref = await SharedPreferences.getInstance();
      print(pref.getKeys());
      token = pref.getString('token');
      publicKey = pref.getString('public_key');
      privateKey = pref.getString('private_key');
    });
  }

  @override
  Widget build(BuildContext context) {
    final _platformDialogA = AlertDialog(
      backgroundColor: Colors.black,
      title: Text("SUBMIT TRANSACTION"),
      content: Text("Are you sure to submit ?"),
      contentTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      titleTextStyle: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      actions: [
        TextButton(
          onPressed: () async {
            EOSPrivateKey pk = EOSPrivateKey.fromString(privateKey);

            var timestamp = DateTime.now().millisecondsSinceEpoch;

            String data =
                timestamp.toString() + recipientPublicKey.toString() + coins;
            final message = utf8.encode(data);

            final hash = await cg.sha256.hash(message);

            EOSSignature signature = pk.signString(hex.encode(hash.bytes));

            var transaction = Transaction(
                fromAddress: publicKey,
                toAddress: recipientPublicKey,
                amount: int.parse(coins),
                timestamp: timestamp,
                signature: signature.toString());

            Map body = <String, String>{
              'token': token,
              'timestamp': transaction.timestamp.toString(),
              'roll_no': rollNo,
              'to_address': transaction.toAddress,
              'amount': transaction.amount.toString(),
              'signature': transaction.signature
            };
            Navigator.pop(context);
            print(body);
            waitTransAndroid(context);
            final res =
                await http.post('https://cryptocrit.herokuapp.com/transaction',
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(body));
            if (res.statusCode != 200) {
              print(res.body);
              unscStatusAndroid(context, res);
              // final sb = SnackBar(
              //   content: Text(res.body),
              // );
              // Scaffold.of(context).showSnackBar(sb);
            } else {
              print("going");
              // final sb = SnackBar(
              //   content: Text("Transaction in process"),
              // );
              // Scaffold.of(context).showSnackBar(sb);
              Navigator.pop(context);
              transStatusAndroid(context);
            }
          },
          child: Text(
            "Yes",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
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

    final _platformDialogC = CupertinoAlertDialog(
      title: new Text(
        "SUBMIT TRANSACTION",
        style: TextStyle(fontSize: 20),
      ),
      content: new Text(
        "Are you sure to submit ?",
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text("Yes"),
          onPressed: () async {
            EOSPrivateKey pk = EOSPrivateKey.fromString(privateKey);
            var timestamp = DateTime.now().millisecondsSinceEpoch;

            String data =
                timestamp.toString() + recipientPublicKey.toString() + coins;
            final message = utf8.encode(data);

            final hash = await cg.sha256.hash(message);

            EOSSignature signature = pk.signString(hex.encode(hash.bytes));

            var transaction = Transaction(
                fromAddress: publicKey,
                toAddress: recipientPublicKey,
                amount: int.parse(coins),
                timestamp: timestamp,
                signature: signature.toString());

            Map body = <String, String>{
              'token': token,
              'timestamp': transaction.timestamp.toString(),
              'to_address': transaction.toAddress,
              'roll_no': rollNo,
              'amount': transaction.amount.toString(),
              'signature': transaction.signature
            };
            Navigator.pop(context);
            waitTransIos(context);
            print(body);
            final res =
                await http.post('https://cryptocrit.herokuapp.com/transaction',
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(body));
            if (res.statusCode != 200) {
              Navigator.pop(context);
              unscStatusIos(context, res);
              //print(res.body);
              // final sb = SnackBar(
              //   content: Text(res.body),
              // );
              // Scaffold.of(context).showSnackBar(sb);
            } else {
              print("going");
              // final sb = SnackBar(
              //   content: Text("Transaction in process"),
              // );
              // Scaffold.of(context).showSnackBar(sb);
              Navigator.pop(context);
              transStatusIos(context);
            }
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

    final transactCoins = TextField(
      controller: trController,
      keyboardType: TextInputType.number,
      autofocus: false,
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
        fillColor: Colors.grey[900],
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Enter Amount",
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: Color(0xff7e57c2), width: 4),
        ),
      ),
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
              coins = trController.text;
              showDialog(
                  context: context,
                  builder: (context) {
                    if (Platform.isAndroid || Platform.isWindows) {
                      return _platformDialogA;
                    } else if (Platform.isIOS || Platform.isIOS) {
                      return _platformDialogC;
                    }
                  });
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            },
            child: AutoSizeText(
              "Submit",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
              overflowReplacement: Icon(
                Icons.send,
                color: Colors.white,
                size: 25,
              ),
              maxLines: 1,
            ),
          ),
        ));

    final height1 = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff7e57c2),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 3,
              child: SizedBox(
                height: height1 * 0.35,
                child: Center(
                  child: AutoSizeText(
                    "Send CC to $rollNo",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxFontSize: 30,
                  ),
                ),
              ),
            ),
            Flexible(flex: 1, child: transactCoins),
            Flexible(flex: 2, child: SizedBox(height: height1 * 0.05)),
            Flexible(flex: 1, child: submitButton),
          ],
        ),
      ),
    );
  }
}

void transStatusAndroid(BuildContext context) {
  final data1 = jsonDecode(ModalRoute.of(context).settings.arguments);
  bool fromHistory = data1['from_history'] == 'true';

  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              "SUCCESS",
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              "Your transaction has been successful",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    if (fromHistory) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.popAndPushNamed(context, '/home');
                    } else {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.popAndPushNamed(context, '/home');
                    }
                  },
                  child: Text("Done"))
            ],
          ));
}

void transStatusIos(BuildContext context) {
  final data = jsonDecode(ModalRoute.of(context).settings.arguments);
  bool fromHistory = data['from_history'] == 'true';

  showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: Text(
              "Success",
              style: TextStyle(fontFamily: 'SanFrancisco'),
            ),
            content: Text("Your transaction has been successful"),
            actions: [
              CupertinoDialogAction(
                child: Text("Okay"),
                onPressed: () {
                  if (fromHistory == true) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.popAndPushNamed(context, '/home');
                  } else {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.popAndPushNamed(context, '/home');
                  }
                },
              )
            ],
          ));
}

void waitTransAndroid(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              "PROCESSING TRANSACTION",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: Text(
              "Your transaction is being processed. Please wait",
              style: TextStyle(color: Colors.white),
            ),
          ));
}

void waitTransIos(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: Text(
              "PROCESSING TRANSACTION",
              style: TextStyle(
                  fontFamily: 'SanFranciso', fontWeight: FontWeight.bold),
            ),
            content: Text(
              "Your transaction is being processed. Please wait",
              style: TextStyle(fontFamily: 'SanFrancisco'),
            ),
          ));
}

void unscStatusIos(BuildContext context, var res) {
  final data = jsonDecode(ModalRoute.of(context).settings.arguments);
  bool fromHistory = data['from_history'] == 'true';

  showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: Text(
              "ERROR",
              style: TextStyle(
                  fontFamily: 'SanFrancisco', fontWeight: FontWeight.bold),
            ),
            content: Text(
              "Your transaction has been unsuccessful \nError: ${res.body}",
              style: TextStyle(fontFamily: 'SanFrancisco'),
            ),
            actions: [
              CupertinoDialogAction(
                child: Text("Okay"),
                onPressed: () {
                  if (fromHistory == true) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.popAndPushNamed(context, '/home');
                  } else {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.popAndPushNamed(context, '/home');
                  }
                },
              )
            ],
          ));
}

void unscStatusAndroid(BuildContext context, var res) {
  final data = jsonDecode(ModalRoute.of(context).settings.arguments);
  bool fromHistory = data['from_history'] == 'true';

  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              "ERROR",
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
                "Your transaction has been unsuccessful.\nError: ${res.body}",
                style: TextStyle(color: Colors.white)),
            actions: [
              TextButton(
                  onPressed: () {
                    if (fromHistory == true) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.popAndPushNamed(context, '/home');
                    } else {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.popAndPushNamed(context, '/home');
                    }
                  },
                  child: Text("Done"))
            ],
          ));
}

void unscStatusWeb(BuildContext context, var res) {
  final data = jsonDecode(ModalRoute.of(context).settings.arguments);
  bool fromHistory = data['from_history'] == 'true';

  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              "ERROR",
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
                "Your transaction has been unsuccessful.\nError: ${res.body}",
                style: TextStyle(color: Colors.white)),
            actions: [
              TextButton(
                  onPressed: () {
                    if (fromHistory == true) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.popAndPushNamed(context, '/home');
                    } else {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.popAndPushNamed(context, '/home');
                    }
                  },
                  child: Text("Done"))
            ],
          ));
}
