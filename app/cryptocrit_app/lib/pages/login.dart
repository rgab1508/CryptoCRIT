import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}


class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: SafeArea(
        child: Column(
          children: [
            FormBuilderField(builder: (FormFieldState<dynamic> fields) {

            }, name: null)
          ],
        ),
      ),
    );
  }
}

