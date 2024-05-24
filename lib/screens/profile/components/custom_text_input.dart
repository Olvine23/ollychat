import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
   final TextEditingController controller;
   final String text;
   final int lines;

   const CustomTextInput({super.key, 
    
  required this.controller, required this.text, required this.lines})  ;

 
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: lines,
      maxLines: lines,
      decoration:  InputDecoration(
        
        labelText: text,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold)
        ),
    );
  }
}
