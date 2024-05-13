import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_repository/user_repository.dart';

class PostEntity{

  String id;
  String title;
  String? body;
  String? thumbnail;
  DateTime createdAt;
  String? genre;
  MyUser myUser;


  PostEntity(
      {
        required this.id,
        required this.title,
        required this.myUser,
        required this.createdAt,
        this.genre,
        this.thumbnail, 
        this.body
        }
        );

  //create a toJson object
  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt,
      'thumbnail': thumbnail,
      'myUser': myUser.toEntity().toDocument(),
      'body':body,
      'genre':genre
    };
  }

  //create a fromJson object

  static PostEntity fromDocument(Map<String, dynamic> doc) {
    return PostEntity(
       id: doc['id'] as String,
       title: doc['title'] as String,
       thumbnail: doc['thumbnail'] as String?,
       body: doc['body'] as String?,
       createdAt:   (doc['createdAt'] as Timestamp).toDate(),
       myUser:  MyUser.fromEntity(MyUserEntity.fromDocument(doc['myUser'])),
       genre: doc['genre'] as String?

       
       );
  }

  @override
  List<Object?> get props => [id, thumbnail,title, createdAt,myUser, genre];

  @override
  String toString() {
    return '''UserEntity:{
       id:$id
      title:$title
      createdAt:$createdAt
      thumbnail:$thumbnail
      myUser:$myUser
      body:$body
      genre:$genre
    }


''';
  }
  
}