import 'package:flutter/material.dart';

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
    print('Transaction build run');
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Send coins'),
        centerTitle: true,
        backgroundColor: Colors.grey[800],
      ),
      body: Text('This is a transaction page'),
    );
  }
}
