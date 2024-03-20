import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String name;
  final String? image;
  final String email;
  final String id;

  MyUserEntity(
      {required this.name, this.image, required this.email, required this.id});

  //create a toJson object
  Map<String, Object> toJson() {
    return {
      'id': id,
      'image': image!,
      'email': email,
      'name': name,
    };
  }

  //create a fromJson object

  static MyUserEntity fromJson(Map<String, dynamic> doc) {
    return MyUserEntity(
        name: doc['name'] as String,
        email: doc['email'] as String,
        id: doc['id'] as String,
        image: doc['image'] as String?);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [name, id, image, email];

  @override
  String toString() {
    return '''UserEntity:{

      id:$id,
      email:$email,
      name:$name,
      image:$image

    }


''';
  }
}
