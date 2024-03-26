import 'package:user_repository/user_repository.dart';

class PostEntity{

   String id;
  String title;
  String? thumbnail;
  DateTime createdAt;
  MyUser myUser;


  PostEntity(
      {
        required this.id,
        required this.title,
        required this.myUser,
        required this.createdAt,
        this.thumbnail, 
        }
        );

  //create a toJson object
  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt,
      'thumbnail': thumbnail,
      'myUser': myUser.toEntity().toDocument()
    };
  }

  //create a fromJson object

  static PostEntity fromDocument(Map<String, dynamic> doc) {
    return PostEntity(
       id: doc['id'] as String,
       title: doc['title'] as String,
       thumbnail: doc['thumbnail'] as String?,
       createdAt: DateTime.parse(doc['createdAt']),
       myUser:  MyUser.fromEntity(MyUserEntity.fromDocument(doc['myUser']))

       
       );
  }

  @override
  List<Object?> get props => [id, thumbnail,title, createdAt,myUser];

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