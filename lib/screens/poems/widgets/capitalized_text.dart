import 'package:flutter/material.dart';

class CapitalizedText extends StatelessWidget {
  final String text;
  final double fontSize;

  CapitalizedText({required this.text, this.fontSize = 16.0});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.isNotEmpty
          ? text.substring(0, 1).toUpperCase() + text.substring(1)
          : text,
      style: TextStyle(fontSize: fontSize),
    );
  }
}
