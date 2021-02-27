import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LogoScreen extends StatefulWidget {
  @override
  _LogoScreenState createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  bool logged = false;

  Future<void> checkLoggedIn() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final pk = pref.getString('private_key');
    if (token != null && pk != null) {
      logged = true;
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image(
          image: AssetImage('assets/logo.png'),
          width: MediaQuery.of(context).size.width * 0.65,
        ),
      ),
    );
  }
}
