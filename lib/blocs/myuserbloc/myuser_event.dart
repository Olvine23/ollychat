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



 