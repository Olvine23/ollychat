import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/src/models/models.dart';

abstract class UserRepository{

  Stream<User?>  get user;

  Future<void> signIn(String email, String password);

  Future<void> logOut();

  Future<MyUser> signUp(MyUser myUser, String password);

  Future<void> resetPassword(String email);

  // setUserData

  Future<void> setUserData(MyUser user);


  //get UserData

  Future<MyUser> getMyUser(String myUserId);


  //upload picture

  Future<String> uploadPicture(String file, String userId);

    



}