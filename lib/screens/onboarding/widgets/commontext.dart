import 'package:flutter/material.dart';
import 'package:olly_chat/theme/colors.dart';

class CommonText extends StatelessWidget {
  final String text;
  const CommonText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style:Theme.of(context).textTheme.headlineSmall!.copyWith(
      fontSize: 18,
      fontWeight:FontWeight.bold, color: AppColors.primaryColor),);
  }
}