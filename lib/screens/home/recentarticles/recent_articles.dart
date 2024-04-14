import 'package:flutter/material.dart';
import 'package:post_repository/post_repository.dart';

class RecentArticles extends StatelessWidget {
  final List<Post> posts;
  const RecentArticles({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    print(posts.length);
    return  Scaffold(
      body: Center(child: Text("${posts.length} articles"),),
    );
  }
}