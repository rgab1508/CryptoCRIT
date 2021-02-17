import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cryptocrit_app/pages/home.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  /*void HomeEnter() async {
    Navigator.pushReplacementNamed(
        context,
        '/home',
    );
  }*/

  @override
  void initState() {
    super.initState();
    print("Application loaded");
    //HomeEnter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitDoubleBounce(
            color: Colors.white,
            size: 85.0,
          ),
          SizedBox(height: 10.0,),
          Text(
            'LOADING',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
