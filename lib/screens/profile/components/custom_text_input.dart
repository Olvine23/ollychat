import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
   final TextEditingController controller;
   final String text;

   const CustomTextInput({super.key, 
    
  required this.controller, required this.text})  ;

 
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration:  InputDecoration(
        
        labelText: text,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold)
        ),
    );
  }
}
