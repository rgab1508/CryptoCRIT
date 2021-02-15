import 'package:flutter/material.dart';

class Blockchain extends StatefulWidget {
  @override
  _BlockchainState createState() => _BlockchainState();
}

class _BlockchainState extends State<Blockchain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BLOCKCHAIN"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
    );
  }
}
