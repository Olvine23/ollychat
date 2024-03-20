part of 'myuser_bloc.dart';

 
abstract class MyuserEvent extends Equatable {

  @override

  List<Object> get props => [];
}

class GetMyUser extends MyuserEvent{
  final String myUserId;

  GetMyUser({
    required this.myUserId
  });

  @override

  List<Object> get props => [myUserId];



}