import 'package:flutter/material.dart';
import 'package:olly_chat/theme/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color butttonColor;
  final dynamic onPressed;
  const CustomButton({super.key, required this.text, required this.onPressed, required this.butttonColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: butttonColor,

          minimumSize: const Size.fromHeight(60), //
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ));
  }
}
