import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? image;


  const MyUserEntity(
      {
        required this.id,
        required this.email,
        required this.name,
        this.image, 
        }
        );

  //create a toJson object
  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'image': image,
    };
  }

  //create a fromJson object

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
       id: doc['id'] as String,
       email: doc['email'] as String,
       name: doc['name'] as String,
       image: doc['image'] as String?);
  }

  @override
  List<Object?> get props => [id, email,name, image];

  @override
  String toString() {
    return '''UserEntity:{
       id:$id
      name:$name
      email:$email
      image:$image
    }


''';
  }
}