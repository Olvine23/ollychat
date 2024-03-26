import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:post_repository/post_repository.dart';
 
import 'package:post_repository/src/models/post.dart';
import 'package:uuid/uuid.dart';
 


class FirebasePostRepository implements PostRepository{

   final postCollection = FirebaseFirestore.instance.collection('artcollection');

  @override
  Future<Post> createPost(Post post) async {
    try {
			post.id = const Uuid().v4();
			post.createdAt = DateTime.now();

      await postCollection
				.doc(post.id)
				.set(post.toEntity().toDocument());

			return post;
    } catch (e) {
      log(e.toString());
			rethrow;
    }
  
  }


 @override
  Future<List<Post>> getPost() {
    try {
      return postCollection
				.get()
				.then((value) => value.docs.map((e) => 
					Post.fromEntity(PostEntity.fromDocument(e.data()))
				).toList());
    } catch (e) {
      print(e.toString());
			rethrow;
    }
  }


}


 
   

  
  
  