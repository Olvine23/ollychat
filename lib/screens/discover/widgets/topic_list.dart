import 'package:flutter/material.dart';
import 'package:olly_chat/screens/discover/components/container_image.dart';

class TopicList extends StatelessWidget {
  const TopicList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2 - 240,
      child: ListView.builder(
        cacheExtent: 1000,
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ContainerImage(),
          );
        },
      ),
    );
  }
}
