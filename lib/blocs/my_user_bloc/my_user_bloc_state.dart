part of 'my_user_bloc_bloc.dart';

sealed class MyUserBlocState extends Equatable {
  const MyUserBlocState();
  
  @override
  List<Object> get props => [];
}

final class MyUserBlocInitial extends MyUserBlocState {}
