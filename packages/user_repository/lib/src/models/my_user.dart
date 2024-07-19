import 'package:equatable/equatable.dart';
import 'package:user_repository/src/entities/entities.dart';

class MyUser extends Equatable {
  final String id;
  final String email;
  final String name;
  String? image;
  String? bio;
  String? handle;
  List<String>? followers;
  List<String>? following;
  List<String>? bookmarkedPosts;



  MyUser({
    required this.id,
    required this.email,
    required this.name,
    this.image,
    this.bio,
    this.handle,
     this.followers = const [],
    this.following = const [],
    this.bookmarkedPosts
  });

  // Unauthenticated user with empty values
  static final empty = MyUser(
    id: '',
    email: '',
    name: '',
    image: '',
    bio: '',
    handle: '',
    followers: const [],
    bookmarkedPosts: const [],
    following: const [],
  );

  // For modification of MyUser params
  MyUser copyWith({
    String? id,
    String? email,
    String? name,
    String? image,
    String? bio,
    String? handle,
    List<String>? followers,
    List<String>? following,
    List<String>? bookmarkedPosts,
  }) {
    return MyUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      image: image ?? this.image,
      bio: bio ?? this.bio,
      handle: handle ?? this.handle,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      bookmarkedPosts: bookmarkedPosts ?? this.bookmarkedPosts
    );
  }

  // Getter that checks whether a user is empty
  bool get isEmpty => this == MyUser.empty;

  // Getter that checks whether a user is not empty
  bool get isNotEmpty => this != MyUser.empty;

  MyUserEntity toEntity() {
    return MyUserEntity(
      id: id,
      email: email,
      name: name,
      image: image,
      bio: bio,
      handle: handle,
      followers: followers ?? [],
      following: following ?? [],
      bookmarkedPosts: bookmarkedPosts ?? []
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      id: entity.id,
      name: entity.name,
      image: entity.image,
      email: entity.email,
      handle: entity.handle,
      bio: entity.bio,
      followers: entity.followers,
      following: entity.following,
      bookmarkedPosts: entity.bookmarkedPosts
    );
  }

  @override
  // Implement props
  List<Object?> get props => [id, email, name, image, bio, handle, followers, following, bookmarkedPosts];
}
