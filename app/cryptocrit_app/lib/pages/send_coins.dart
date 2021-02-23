import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'dart:convert';


class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {

  @override
  void initState() {
    // TODO: Implement transaction function.
    super.initState();
    print('Transaction initState run');
  }

  @override
  Widget build(BuildContext context) {

    final myController = TextEditingController();
    final trController = TextEditingController();
    final pkController = TextEditingController();
    String coins;
    String rollNo;
    String pk;
    Map data;



    @override
    void dispose() {
      myController.dispose();
      trController.dispose();
      super.dispose();
    }

    final transactCoins = TextField(
      controller: trController,
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
          hintText: 'Enter the amount',
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          )),
    );

    final rollField = TextField(
      controller: myController,
      autofocus: true,
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
          hintText: "Enter Roll No. ( Press enter )",
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          )
      ),
      onSubmitted: (rollNo) async {
        Response response = await get('https://cryptocrit.herokuapp.com/user?rollno=$rollNo');
        if(response.statusCode == 200) {
          data = json.decode(response.body);
          pkController.text = data['public_key'];
          print(data);
        }
        else {
          pkController.text = "Not found";
          print(response.body);
        }
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );

    //pk = data['public_key'];

    final publicKey = TextField(
      cursorColor: Colors.white,
      controller: pkController,
      readOnly: true,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Get public key here",
        hintStyle: TextStyle(
          color: Colors.grey[400]
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        )
      ),
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
              coins = trController.text;
            },
            child: AutoSizeText(
              "Submit",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));

    final qrButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30),
        color: Colors.blue,
        child: Builder(
          builder: (context) => MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            onPressed: () async {

            },
            child: AutoSizeText(
              "Scan QR code",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));

    double height1 = MediaQuery.of(context).size.height;

    print('Transaction build run');
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Send coins'),
        centerTitle: true,
        backgroundColor: Colors.grey[800],
      ),
      body: Padding(
        padding: EdgeInsets.all(13.0),
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: SizedBox(
                height: 155.0,
                child: AutoSizeText(
                  "Send coins",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    //fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                  minFontSize: 25,
                ),
              ),
            ),
            Flexible(flex: 1,child: rollField),
            SizedBox(height: height1*0.01 ),
            Flexible(child: publicKey,flex: 1),
            SizedBox(height: height1*0.01),
            Flexible(child: transactCoins, flex: 1),
            SizedBox(height: height1*0.03),
            Flexible(child: submitButton, flex: 1),
            Flexible(child: SizedBox(height: height1*0.05), flex: 1),
            Flexible(child: qrButton, flex: 1)
          ],
        ),
      ),
    );
  }
}
