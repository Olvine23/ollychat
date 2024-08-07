import 'package:flutter/material.dart';

class RowTitle extends StatelessWidget {
  final String text;
  const RowTitle({
    super.key, required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold, ),
    );
  }
}