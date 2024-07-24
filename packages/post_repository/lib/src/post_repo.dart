import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_repository/user_repository.dart';

import 'models/models.dart';

abstract class PostRepository {
  Future<Post> createPost(Post post, String file);

  Future<List<Post>> searchPosts(String query);

  Future<List<Post>> getPost({DocumentSnapshot? startAfter});

  Stream<List<Post>> getStreamPost();

  Future<List<Post>> getPostsByCategory(String category,
      {DocumentSnapshot? startAfter});

  Future<void> updateAllPostsForUser(MyUser updatedUser);
}
