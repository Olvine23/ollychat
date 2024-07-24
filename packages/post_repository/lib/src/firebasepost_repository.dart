import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:post_repository/post_repository.dart';
 
import 'package:post_repository/src/models/post.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';
 


 class FirebasePostRepository implements PostRepository {
  final postCollection = FirebaseFirestore.instance.collection('artcollection');
  final storage = FirebaseStorage.instance;
   final int postsPerPage = 10; // Define the number of posts per page

    @override
      Future<List<Post>> searchPosts(String query) async {
    try {
      QuerySnapshot querySnapshot = await postCollection
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      return querySnapshot.docs.map((doc) =>
        Post.fromEntity(PostEntity.fromDocument(doc.data() as Map<String, dynamic>))
      ).toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

   Future<void> sendNotification(String title, String content) async {
    final response = await http.post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'NTU1NjYwMDEtZjgyMy00ZDg3LWI3Y2EtM2QyZmY1N2JmNTIx',
      },
      body: jsonEncode({
        'app_id': 'ed03b794-a7a6-4e2c-893b-a859ce8da8fb',
        'included_segments': ['All'],
        'headings': {'en': title},
        'contents': {'en': content},
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send notification');
    }
  }

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

      

      //  await sendNotification('New Article Published', post.title);

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
  Future<List<Post>> getPost({DocumentSnapshot? startAfter}) async {
  try {
    Query query = postCollection.orderBy('createdAt', descending: true);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    QuerySnapshot querySnapshot = await query.get();

    return querySnapshot.docs.map((doc) =>
      Post.fromEntity(PostEntity.fromDocument(doc.data() as Map<String, dynamic>))
    ).toList();
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

  //fetch by category
   @override
     Future<List<Post>> getPostsByCategory(String category, {DocumentSnapshot? startAfter}) async {
    try {
      Query query = postCollection
          .where('genre', isEqualTo: category)
          .orderBy('createdAt', descending: true);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      QuerySnapshot querySnapshot = await query.get();

      return querySnapshot.docs.map((doc) =>
        Post.fromEntity(PostEntity.fromDocument(doc.data() as Map<String, dynamic>))
      ).toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
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
