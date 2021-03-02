import 'package:cryptocrit_app/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/block_model.dart';
//import '../models/transaction_model.dart';

class HomeBlockchain extends StatefulWidget {
  @override
  _HomeBlockchainState createState() => _HomeBlockchainState();
}

class _HomeBlockchainState extends State<HomeBlockchain> {
  List<Block> chain = new List<Block>();
  bool _loading = true;

  Future<void> fetchBlockchain() async {
    String url = "https://cryptocrit.herokuapp.com/blockchain";
    final res = await http.get(url);

    if (res.statusCode == 200) {
      Iterable l = jsonDecode(res.body);
      chain = List<Block>.from(l.map((model) => Block.fromJson(model)));
      setState(() {
        _loading = false;
      });
    } else {
      throw Exception('Failed to load BLockchain');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBlockchain();
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
                        "Blocks",
                        style: TextStyle(
                          fontSize: 50,
                          color: Colors.white,
                        ),
                      )),
                ),
                Flexible(
                  flex: 4,
                  child: Container(
                    height: 555,
                    child: ListView.builder(
                        itemCount: chain.length,
                        itemBuilder: (context, index) => BlockTile(
                              index: chain[index].index,
                              timestamp: chain[index].timestamp,
                              hash: chain[index].hash,
                              prevHash: chain[index].prevHash,
                              nonce: chain[index].nonce,
                              data: chain[index].data,
                            )),
                  ),
                )
              ],
            )),
    );
  }
}

class BlockTile extends StatelessWidget {
  final int index;
  final int timestamp;
  final String hash;
  final String prevHash;
  final int difficulty;
  final nonce;
  final Transaction data;

  BlockTile(
      {this.index,
      this.timestamp,
      this.hash,
      this.prevHash,
      this.difficulty,
      this.nonce,
      this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 2.0),
        child: ListTile(
          leading: Text(
            index.toString(),
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          title: Text(
            data == null
                ? "Block " + index.toString()
                : data.toRollNo.toString() +
                    " -> " +
                    data.fromRollNo.toString(),
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            DateTime.fromMillisecondsSinceEpoch(timestamp)
                .toString()
                .substring(0, 19),
            style: TextStyle(color: Colors.white),
          ),
          tileColor: Colors.grey[900],
        ),
      ),
    );
  }
}
