import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/src/models/models.dart';

abstract class UserRepository {
  Stream<User?> get user;


  Future<List<MyUser>> getAllUsers();

  Future<void> signIn(String email, String password);

  Future<void> logOut();

  Future<MyUser> signUp(MyUser myUser, String password);

  Future<void> resetPassword(String email);

  // Set user data
  Future<void> setUserData(MyUser user);

  // Get user data
  Future<MyUser> getMyUser(String myUserId);

  // Upload picture
  Future<String> uploadPicture(String file, String userId);

  // Update user data
  Future<void> updateUserData(String userId, Map<String, dynamic> updates);

   Future<void> followUser(String currentUserId, String targetUserId);
  Future<void> unfollowUser(String currentUserId, String targetUserId);
  Future<int> getFollowersCount(String userId);
  Future<int> getFollowingCount(String userId);
}
