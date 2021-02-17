import 'package:cryptocrit_app/pages/home_blockchain.dart';
import 'package:cryptocrit_app/pages/home_transaction.dart';
import 'package:cryptocrit_app/pages/blockchain.dart';
import 'package:cryptocrit_app/pages/profile.dart';
import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _currentIndex = 0;
  final List<Widget> _children1 = [
    HomeTransaction(),
    HomeBlockchain(),
    Blockchain(),
    Profile(),
  ];

  void onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children1[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        unselectedItemColor: Colors.white70,
        selectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Transactions',
            backgroundColor: Colors.grey[800]
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
            backgroundColor: Colors.grey[800],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.desktop_mac),
            label: 'Blockchain',
            backgroundColor: Colors.grey[800],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Profile',
            backgroundColor: Colors.grey[800],
          ),
        ],
        onTap: onTapped,

      ),
    );
  }
}

