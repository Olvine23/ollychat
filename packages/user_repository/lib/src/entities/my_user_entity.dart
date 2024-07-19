import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? bio;
  final String? handle;
  final String? image;
  final List<String> followers;
  final List<String> following;
  final List<String> bookmarkedPosts;

  const MyUserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.image,
    this.bio,
    this.handle,
    this.followers = const [],
    this.bookmarkedPosts = const [],
    this.following = const [],
  });

  // Create a toDocument object
  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'image': image,
      'bio': bio,
      'handle': handle,
      'followers': followers,
      'following': following,
      'bookmarkedPosts': bookmarkedPosts
    };
  }

  // Create a fromDocument object
  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      id: doc['id'] as String,
      email: doc['email'] as String,
      name: doc['name'] as String,
      image: doc['image'] as String?,
      bio: doc['bio'] as String?,
      handle: doc['handle'] as String?,
      followers: List<String>.from(doc['followers'] ?? []),
      following: List<String>.from(doc['following'] ?? []),
      bookmarkedPosts: List<String>.from(doc['bookmarkedPosts'] ?? []),
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        image,
        bio,
        handle,
        followers,
        following,
        bookmarkedPosts
      ];

  @override
  String toString() {
    return '''UserEntity: {
      id: $id,
      name: $name,
      email: $email,
      image: $image,
      bio: $bio,
      handle: $handle,
      followers: $followers,
      bookmarkedPosts:$bookmarkedPosts,
      following: $following
    }''';
  }
}
