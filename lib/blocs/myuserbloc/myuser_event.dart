part of 'myuser_bloc.dart';

 
abstract class MyUserEvent extends Equatable {
  const MyUserEvent();

  @override

  List<Object> get props => [];
}

class GetMyUser extends MyUserEvent{
  final String myUserId;

  const GetMyUser({
    required this.myUserId
  });

  @override

  List<Object> get props => [myUserId];



}

class FollowUser extends MyUserEvent {
  final String currentUserId;
  final String targetUserId;

  const FollowUser(this.currentUserId, this.targetUserId);

  @override
  List<Object> get props => [currentUserId, targetUserId];
}

class UnfollowUser extends MyUserEvent {
  final String currentUserId;
  final String targetUserId;

  const UnfollowUser(this.currentUserId, this.targetUserId);

  @override
  List<Object> get props => [currentUserId, targetUserId];
}

class GetAllUsers extends MyUserEvent {}

class BookmarkPost extends MyUserEvent {
  final String userId;
  final String postId;

  const BookmarkPost(this.userId, this.postId);

  @override
  List<Object> get props => [userId, postId];
}

class UnbookmarkPost extends MyUserEvent {
  final String userId;
  final String postId;

  const UnbookmarkPost(this.userId, this.postId);

  @override
  List<Object> get props => [userId, postId];
}

class LoadBookmarkedPosts extends MyUserEvent {
  final String userId;

  const LoadBookmarkedPosts(this.userId);

  @override
  List<Object> get props => [userId];
}



 