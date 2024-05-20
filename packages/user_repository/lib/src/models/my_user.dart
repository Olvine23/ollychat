import 'package:equatable/equatable.dart';
import 'package:user_repository/src/entities/entities.dart';

class MyUser extends Equatable {
  final String id;
  final String email;
  final String name;
  String? image;
  String? bio;
  String? handle;

   MyUser(
      {required this.id, required this.email, required this.name, this.image, this.bio, this.handle});

  // unauthenticated user i.e with empty values

  static final empty = MyUser(id: '', email: '', name: '', image: '', bio: '', handle: '');

  //for modification of MyUser params
  MyUser copyWith({
    String? id,
    String? email,
    String? name,
    String? image,
    String? bio,
    String? handle
  }) {
    return MyUser(
        id: id ?? this.id,
        email: email ?? this.email,
        name: name ?? this.name,
        image: image ?? this.image,
        handle: handle ?? this.handle,
        bio: bio ?? this.bio
      

        );
  }

  //getter that checks whether a user is empty
  bool get isEmpty => this == MyUser.empty;

//getter that checks whether a user is not empty

  bool get isNotEmpty => this != MyUser.empty;

  MyUserEntity toEntity(){
    return MyUserEntity(
      id:id,
      email:email,
      name:name,
      image:image,
      bio: bio,
      handle: handle


    );
  }

  static MyUser fromEntity(MyUserEntity entity){
    return MyUser(
      id: entity.id,
      name: entity.name,
      image: entity.image,
      email: entity.email,
      handle: entity.handle,
      bio: entity.bio
      
      );
  }

  @override
  // implement props
  List<Object?> get props => [id, email, name, image, bio, handle];
}
