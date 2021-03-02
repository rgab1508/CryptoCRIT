import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvatarSelect extends StatefulWidget {
  @override
  _AvatarSelectState createState() => _AvatarSelectState();
}

class _AvatarSelectState extends State<AvatarSelect> {
  int no = 1;
  var url;
  var avatar = "";
  bool _loading = true;

  Future<void> getAvatar() async {
    no = Random().nextInt(100000000);
    setState(() {
      _loading = false;
      avatar = "https://avatars.dicebear.com/api/bottts/" +
          no.toString() +
          ".svg?r=20&b=%23000000";
    });
  }

  @override
  void initState() {
    super.initState();
    getAvatar();
  }

  @override
  Widget build(BuildContext context) {
    final nextButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30),
        color: Color(0xff7e57c2),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width * 0.65,
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          onPressed: () async {
            final pref = await SharedPreferences.getInstance();
            pref.setString('avatar', avatar);
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Text(
            "Next >>",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ));

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoSizeText(
            "SELECT AVATAR",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.height * 0.4,
            child: CircleAvatar(
                backgroundColor: Colors.black,
                child: SvgPicture.network(
                  avatar,
                  fit: BoxFit.fill,
                  semanticsLabel: 'Avatar',
                  placeholderBuilder: (BuildContext context) => Container(
                      padding: const EdgeInsets.all(30.0),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                      )),
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration:
                BoxDecoration(color: Color(0xff7e57c2), shape: BoxShape.circle),
            child: GestureDetector(
              onTap: () {
                getAvatar();
              },
              child: _loading
                  ? CircularProgressIndicator(
                      backgroundColor: Colors.black,
                      strokeWidth: 2,
                    )
                  : Icon((Icons.shuffle), size: 40, color: Colors.white),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          nextButton
        ],
      ),
    );
  }
}
