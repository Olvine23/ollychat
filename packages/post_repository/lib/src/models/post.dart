import 'package:flutter/cupertino.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';

class Post {
  String id;
  String title;
  String? thumbnail;
  DateTime createdAt;
  MyUser myUser;

  Post(
      {required this.id,
      required this.title,
      this.thumbnail,
      required this.createdAt,
      required this.myUser});

  //for modification of empty posts

  static final empty =
      Post(id: '', title: '', createdAt: DateTime.now(), myUser: MyUser.empty, thumbnail: '');

  //for modificartion of  post params
  Post copyWith(
      {String? id,
      String? title,
      String? thumbnail,
      DateTime? createdAt,
      MyUser? myUser}) {
    return Post(
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
        title: title ?? this.title,
        myUser: myUser ?? this.myUser,
        thumbnail: thumbnail ?? this.thumbnail);
  }
  //getter checks for empty posts

  bool get isEmpty => this == Post.empty;

  //checks not empty
  bool get isNotEmpty => this != Post.empty;

  PostEntity toEntity(){
    return PostEntity(
      id:id,
      title:title,
      thumbnail:thumbnail,
      createdAt:createdAt,
      myUser:myUser,
    );

  }

  static Post   fromEntity(PostEntity entity){
    return Post(
      id:entity.id,
      title:entity.title,
      thumbnail:entity.thumbnail,
      createdAt:entity.createdAt,
      myUser:entity.myUser,
    );

  }

 @override
  String toString() {
    return '''UserEntity:{
       id:$id
      title:$title
      createdAt:$createdAt
      thumbnail:$thumbnail
      myUser:$myUser
    }


''';
  }

  


}
