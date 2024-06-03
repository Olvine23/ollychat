import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:user_repository/user_repository.dart';

part 'myuser_event.dart';
part 'myuser_state.dart';

class MyUserBloc extends Bloc<MyUserEvent, MyUserState> {
  final UserRepository _userRepository;
  MyUserBloc({
    required UserRepository myUserRepository,
  })  : _userRepository = myUserRepository,
        super(const MyUserState.loading()) {
    on<GetMyUser>((event, emit) async {
      try {
        MyUser myUser = await _userRepository.getMyUser(event.myUserId);
        emit(MyUserState.success(myUser));
      } catch (e) {
         log(e.toString());
         emit(const MyUserState.failure());
        print(e.toString());
      }
    });

      on<FollowUser>((event, emit) async {
      emit(const MyUserState.loading());
      try {
        await _userRepository.followUser(event.currentUserId, event.targetUserId);
        MyUser myUser = await _userRepository.getMyUser(event.currentUserId);
        emit(MyUserState.success(myUser));
      } catch (e) {
        log(e.toString());
        emit(const MyUserState.failure());
        print(e.toString());
      }
    });

     on<UnfollowUser>((event, emit) async {
      emit(const MyUserState.loading());
      try {
        await _userRepository.unfollowUser(event.currentUserId, event.targetUserId);
        MyUser myUser = await _userRepository.getMyUser(event.currentUserId);
        emit(MyUserState.success(myUser));
      } catch (e) {
        log(e.toString());
        emit(const MyUserState.failure());
        print(e.toString());
      }
    });


       on<GetAllUsers>((event, emit) async {
      try {
        List<MyUser> users = await _userRepository.getAllUsers();
        emit(MyUserState.usersSuccess(users));
      } catch (e) {
        log(e.toString());
        emit(const MyUserState.failure());
      }
    });

    // on<UpdateMyUser>((event, emit) async {
    //   try {
    //     await _userRepository.updateUserData(event.userId, event.updates);
    //     MyUser updatedUser = await _userRepository.getMyUser(event.userId);
    //     emit(MyUserState.success(updatedUser));
    //   } catch (e) {
    //     log(e.toString());
    //     emit(const MyUserState.failure());
    //     print(e.toString());
    //   }
    // });


  }
}
