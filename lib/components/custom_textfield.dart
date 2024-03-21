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
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.greenWhite, // Shadow color
                          spreadRadius: 5, // Spread radius
                          blurRadius: 30, // Blur radius
                          offset: Offset(0, 5), // Offset
                        ),
                      ],
                    ),

      child: TextFormField(
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
             
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide:
                  BorderSide(
                    width: 1.0,
                    color:  AppColors.primaryColor),
            ),
            errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red)),
            // fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500]),
            errorText: errorMsg,
          )),
    );
  }
}
