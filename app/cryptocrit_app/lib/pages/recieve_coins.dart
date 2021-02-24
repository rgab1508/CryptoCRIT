import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceiveCoins extends StatefulWidget {
  @override
  _ReceiveCoinsState createState() => _ReceiveCoinsState();
}

class _ReceiveCoinsState extends State<ReceiveCoins> {
  String publicKey;
  var _loading = true;

  Future<void> getPublicKey() async {
    final pref = await SharedPreferences.getInstance();
    publicKey = pref.getString('public_key');
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getPublicKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Receive coins"),
          centerTitle: true,
          backgroundColor: Colors.grey[800],
          elevation: 0,
        ),
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _loading
                ? Container(
                    child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ))
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.network(
                        'https://chart.googleapis.com/chart?chs=500x500&cht=qr&chl=${publicKey}&choe=UTF-8'),
                  ),
          ],
        ));
  }
}
