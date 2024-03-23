import 'package:flutter/material.dart';

class Greetings extends StatelessWidget {
  final String name;
  const Greetings({
    super.key, required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text("Hello $name 👋", style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}
