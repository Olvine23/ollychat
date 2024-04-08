import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:post_repository/post_repository.dart';
 
import 'package:post_repository/src/models/post.dart';
import 'package:uuid/uuid.dart';
 


class FirebasePostRepository implements PostRepository{

   final postCollection = FirebaseFirestore.instance.collection('artcollection');
    final storage = FirebaseStorage.instance;

  @override
  Future<Post> createPost(Post post,  String image) async {
    try {
			post.id = const Uuid().v4();
			post.createdAt = DateTime.now();

       // Upload image to Firebase Storage if provided
      File imageFile = File(image);

      //create folder path
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
      '${post.id}/PP/${post.id}_lead'
    );
    //get image string

    //upload to firebase storage
    await firebaseStorageRef.putFile(imageFile);


    String url = await firebaseStorageRef.getDownloadURL();


      await postCollection
				.doc(post.id)
				.set(post.toEntity().toDocument());

      await postCollection.doc(post.id).update({

         'thumbnail':url

      }
       
      );

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


@override
Stream<List<Post>> getStreamPost() {
  return postCollection
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Post.fromEntity(PostEntity.fromDocument(doc.data())))
          .toList());
}


}


 
   

  
  
  