import 'package:flutter/material.dart';
import 'package:olly_chat/theme/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final Widget? suffixIcon;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final String? errorMsg;
  final String? Function(String?)? onChanged;

  const CustomTextField(
      {super.key,
      required this.controller,
      this.suffixIcon,
      required this.hintText,
      required this.obscureText,
      required this.keyboardType,
      this.onTap,
      this.prefixIcon,
      this.validator,
      this.focusNode,
      this.errorMsg,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        
      ),
      child: TextFormField(
        style: TextStyle(color: Colors.white), // 👈 typed text will be white
          validator: validator,
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          focusNode: focusNode,
          onTap: onTap,
          textInputAction: TextInputAction.next,
          onChanged: onChanged,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
       border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none, // Optional: no border at all
  ),
            errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red)),
            // fillColor: Colors.grey.shade200,
          fillColor: Colors.white.withOpacity(0.2),

            hintText: hintText,
            hintStyle: TextStyle(color: Colors.white),
            errorText: errorMsg,
          )),
    );
  }
}
