import 'package:flutter/material.dart';

class PlaceHolder extends StatelessWidget {
  final Color color;

  PlaceHolder(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}
