import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:post_repository/post_repository.dart';
 
import 'package:post_repository/src/models/post.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';
 


 class FirebasePostRepository implements PostRepository {
  final postCollection = FirebaseFirestore.instance.collection('artcollection');
  final storage = FirebaseStorage.instance;
   final int postsPerPage = 13; // Define the number of posts per page

  @override
  Future<Post> createPost(Post post, String image) async {
    try {
      post.id = const Uuid().v4();
      post.createdAt = DateTime.now();

      // Upload image to Firebase Storage if provided
      File imageFile = File(image);

      // Create folder path
      Reference firebaseStorageRef = storage.ref().child(
        '${post.id}/PP/${post.id}_lead'
      );

      // Upload to Firebase Storage
      await firebaseStorageRef.putFile(imageFile);

      String url = await firebaseStorageRef.getDownloadURL();

      await postCollection
          .doc(post.id)
          .set(post.toEntity().toDocument());

      await postCollection.doc(post.id).update({
        'thumbnail': url
      });

      return post;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // Function to update all posts with the latest user information
  Future<void> updateAllPostsForUser(MyUser updatedUser) async {
    try {
      // Fetch all posts by the user
      QuerySnapshot querySnapshot = await postCollection.where('myUser.id', isEqualTo: updatedUser.id).get();

      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Post post = Post.fromEntity(PostEntity.fromDocument(doc.data() as Map<String, dynamic>));
        
        // Update the user information in the post
        post = post.copyWith(myUser: updatedUser);
        
        // Add update operation to the batch
        batch.update(postCollection.doc(post.id), post.toEntity().toDocument());
      }

      // Commit the batch
      await batch.commit();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
   Future<List<Post>> getPost(int page) {
    try {
      return postCollection.orderBy('createdAt', descending: true)
          .limit(postsPerPage) // Limit the number of posts per page
          .get()
          .then((value) => value.docs.map((e) =>
              Post.fromEntity(PostEntity.fromDocument(e.data()))
          ).toList());
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Stream<List<Post>> getStreamPost() {
    return postCollection
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Post.fromEntity(PostEntity.fromDocument(doc.data())))
        .toList());
  }

  Future<void> updateUserInPosts(MyUser updatedUser) async {
    try {
      final postsQuerySnapshot = await postCollection
          .where('myUser.id', isEqualTo: updatedUser.id)
          .get();

      final batch = FirebaseFirestore.instance.batch();

      for (final doc in postsQuerySnapshot.docs) {
        batch.update(doc.reference, {'myUser': updatedUser.toEntity().toDocument()});
      }

      await batch.commit();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
