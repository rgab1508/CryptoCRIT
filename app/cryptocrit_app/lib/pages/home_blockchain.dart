import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/block_model.dart';
import '../models/transaction_model.dart';

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

  void fetchDemoBlock() {
    Block b = new Block(
        index: 0,
        difficulty: 30,
        nonce: 313,
        hash: "sabfdbkfddkjbckjckdb",
        prevHash: "asjdiasbckabcusacjnkncoidfdjnscnodu",
        timestamp: 132468754613);
    chain.add(b);
    b = new Block(
        index: 1,
        difficulty: 29,
        nonce: 1234,
        hash: "sabfdbkfddksabfdbkfddkjbckjckdbjbckjckdb",
        prevHash: "asjdiasbckabsabfdbkfddkjbckjckdbcusacjnkncoidfdjnscnodu",
        timestamp: 132468755000);
    chain.add(b);
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    //fetchDemoBlock();
    fetchBlockchain();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? Container(
              child: Center(
              child: CircularProgressIndicator(),
            ))
          : Container(
              child: Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      "Blocks",
                      style: TextStyle(fontSize: 50),
                    )),
                Container(
                  height: 500,
                  child: ListView.builder(
                      itemCount: chain.length,
                      itemBuilder: (context, index) => BlockTile(
                            index: chain[index].index,
                            timestamp: chain[index].timestamp,
                            hash: chain[index].hash,
                            prevHash: chain[index].prevHash,
                            nonce: chain[index].nonce,
                          )),
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

  BlockTile(
      {this.index,
      this.timestamp,
      this.hash,
      this.prevHash,
      this.difficulty,
      this.nonce});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: Text("Block" + index.toString()),
        subtitle: Text(nonce.toString()),
      ),
    );
  }
}
