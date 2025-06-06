import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/src/entities/entities.dart';
import 'package:user_repository/src/models/my_user.dart';
import 'package:user_repository/src/user_repo.dart';

class FirebaseUserRepo implements UserRepository {
  final postRepository = FirebasePostRepository();
  
  FirebaseUserRepo({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;
  final usersCollection = FirebaseFirestore.instance.collection('users');

 
Future<String?> saveFcmToken(String userId) async {
  final token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'fcmToken': token,
    });
    return token;
  }
  return null;
}

void startFCMTokenRefreshListener(String userId) {
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    if (newToken != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'fcmToken': newToken,
      }, SetOptions(merge: true));
    }
  });
}


  // Sign up user
  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: myUser.email, password: password);

      myUser = myUser.copyWith(id: user.user!.uid, followers: [], following: []);

      await setUserData(myUser);
      await saveFcmToken(myUser.id);
      startFCMTokenRefreshListener(myUser.id); // after signUp

      return myUser;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

 // Bookmark a post
  Future<void> bookmarkPost(String userId, String postId) async {
    try {
      await usersCollection.doc(userId).update({
        'bookmarkedPosts': FieldValue.arrayUnion([postId])
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

    // Unbookmark a post
  Future<void> unbookmarkPost(String userId, String postId) async {
    try {
      await usersCollection.doc(userId).update({
        'bookmarkedPosts': FieldValue.arrayRemove([postId])
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

   // Get bookmarked posts
  Future<List<Post>> getBookmarkedPosts(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();
      List<String> bookmarkedPosts = List<String>.from(userSnapshot['bookmarkedPosts'] ?? []);

      List<Post> posts = [];
      for (String postId in bookmarkedPosts) {
        DocumentSnapshot postSnapshot = await FirebaseFirestore.instance.collection('artcollection').doc(postId).get();
        if (postSnapshot.exists) {
          posts.add(Post.fromEntity(PostEntity.fromDocument(postSnapshot.data() as Map<String, dynamic>)));
        }
      }
      return posts;
    } catch (e) {
      print(e);
      rethrow;
    }
  }




  // Sign in user
  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
          await saveFcmToken(_firebaseAuth.currentUser!.uid);
          startFCMTokenRefreshListener(_firebaseAuth.currentUser!.uid); // after signIn

    } catch (e) {
      print(e);
    }
  }

  // Sign out
  @override
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print(e);
    }
  }

  // Reset password
  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      log("reset sent to email");
    } catch (e) {
      print(e);
    }
  }

  // Set user data
  @override
  Future<void> setUserData(MyUser user) async {
    try {
      await usersCollection.doc(user.id).set(user.toEntity().toDocument());
    } catch (e) {
      print(e);
    }
  }

  // Get user
  @override
  Future<MyUser> getMyUser(String myUserId) async {
    try {
      return usersCollection.doc(myUserId).get().then(
          (value) => MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!)));
    } catch (e) {
      log(e.toString());
      print(e);
      rethrow;
    }
  }

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser;
      return user;
    });
  }
  
  @override
  Future<String> uploadPicture(String file, String userId) async {
    try {
      // Convert file to string
      File imageFile = File(file);

      // Create folder path
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
        '$userId/PP/${userId}_lead'
      );

      // Upload to Firebase storage
      await firebaseStorageRef.putFile(imageFile);

      // Get image string
      String url = await firebaseStorageRef.getDownloadURL();

      await usersCollection.doc(userId).update({
        'image': url
      });

      return url;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // Update user data
  @override
  Future<void> updateUserData(String userId, Map<String, dynamic> updates) async {
    try {
      await usersCollection.doc(userId).update(updates);

      // Fetch updated user details
      MyUser updatedUser = await getMyUser(userId);

      // Update user details in posts
      await postRepository.updateUserInPosts(updatedUser);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // Follow a user
  Future<void> followUser(String currentUserId, String targetUserId) async {
    try {
      DocumentReference currentUserRef = usersCollection.doc(currentUserId);
      DocumentReference targetUserRef = usersCollection.doc(targetUserId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot currentUserSnapshot = await transaction.get(currentUserRef);
        DocumentSnapshot targetUserSnapshot = await transaction.get(targetUserRef);

        if (!currentUserSnapshot.exists || !targetUserSnapshot.exists) {
          throw Exception("User does not exist!");
        }

        List following = currentUserSnapshot['following'] ?? [];
        List followers = targetUserSnapshot['followers'] ?? [];

        if (!following.contains(targetUserId)) {
          transaction.update(currentUserRef, {
            'following': FieldValue.arrayUnion([targetUserId])
          });
          transaction.update(targetUserRef, {
            'followers': FieldValue.arrayUnion([currentUserId])
          });
        }
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // Unfollow a user
  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    try {
      DocumentReference currentUserRef = usersCollection.doc(currentUserId);
      DocumentReference targetUserRef = usersCollection.doc(targetUserId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot currentUserSnapshot = await transaction.get(currentUserRef);
        DocumentSnapshot targetUserSnapshot = await transaction.get(targetUserRef);

        if (!currentUserSnapshot.exists || !targetUserSnapshot.exists) {
          throw Exception("User does not exist!");
        }

        List following = currentUserSnapshot['following'] ?? [];
        List followers = targetUserSnapshot['followers'] ?? [];

        if (following.contains(targetUserId)) {
          transaction.update(currentUserRef, {
            'following': FieldValue.arrayRemove([targetUserId])
          });
          transaction.update(targetUserRef, {
            'followers': FieldValue.arrayRemove([currentUserId])
          });
        }
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // Get followers count
  Future<int> getFollowersCount(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();
      List followers = userSnapshot['followers'] ?? [];
      return followers.length;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // Get following count
  Future<int> getFollowingCount(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();
      List following = userSnapshot['following'] ?? [];
      return following.length;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<List<MyUser>> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await usersCollection.get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return MyUser.fromEntity(MyUserEntity.fromDocument(data));
      }).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
