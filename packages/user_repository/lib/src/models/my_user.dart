import 'package:equatable/equatable.dart';
import 'package:user_repository/src/entities/entities.dart';

class MyUser extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? image;

  const MyUser(
      {required this.id, required this.email, required this.name, this.image});

  // unauthenticated user i.e with empty values

  static const empty = MyUser(id: '', email: '', name: '', image: '');

  //for modification of MyUser params
  MyUser copyWith({
    String? id,
    String? email,
    String? name,
    String? image,
  }) {
    return MyUser(
        id: id ?? this.id,
        email: email ?? this.email,
        name: name ?? this.name,
        image: image ?? this.image);
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
      image:image
    );
  }

  static MyUser fromEntity(MyUserEntity entity){
    return MyUser(
      id: entity.id,
      name: entity.name,
      image: entity.image,
      email: entity.email);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, email, name, image];
}
