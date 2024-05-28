import 'package:flutter/material.dart';
import 'package:olly_chat/screens/discover/components/writers_container.dart';

class WriterList extends StatelessWidget {
  const WriterList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2 - 260,
      child: ListView.builder(
        cacheExtent: 1000,
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        itemBuilder: (context, index) {
          return const WritersContainer();
        },
      ),
    );
  }
}
