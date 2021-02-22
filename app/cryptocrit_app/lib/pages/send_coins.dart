import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    String coins;

    @override
    void dispose() {
      myController.dispose();
      super.dispose();
    }

    final transactCoins = TextField(
      controller: myController,
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
              coins = myController.text;
              print(coins);
            },
            child: Text(
              "Submit",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));


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
            SizedBox(
              height: 155.0,
              child: Text(
                "Send coins",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  //fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            transactCoins,
            SizedBox(height: 25),
            submitButton,
          ],
        ),
      ),
    );
  }
}
