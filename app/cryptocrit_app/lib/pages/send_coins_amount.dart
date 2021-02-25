import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SendAmountTransactions extends StatefulWidget {
  @override
  _SendAmountTransactionsState createState() => _SendAmountTransactionsState();
}

class _SendAmountTransactionsState extends State<SendAmountTransactions> {
  final trController = TextEditingController();
  var rollNo;
  var publicKey;
  String coins;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final data = jsonDecode(ModalRoute.of(context).settings.arguments);
      rollNo = data['roll_no'];
      publicKey = data['public_key'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactCoins = TextField(
      controller: trController,
      keyboardType: TextInputType.number,
      autofocus: true,
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
                    return AlertDialog(
                      backgroundColor: Colors.black,
                      title: Text("SUBMIT TRANSACTION"),
                      content: Text("Are you sure to submit ?"),
                      contentTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      titleTextStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      actions: [
                        FlatButton(
                          onPressed: () {},
                          child: Text(
                            "Yes",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                            ))
                      ],
                    );
                  });
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
