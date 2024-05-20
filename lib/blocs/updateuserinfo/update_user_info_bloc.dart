import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

part 'update_user_info_event.dart';
part 'update_user_info_state.dart';

class UpdateUserInfoBloc
    extends Bloc<UpdateUserInfoEvent, UpdateUserInfoState> {
  final UserRepository _userRepository;
  UpdateUserInfoBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UpdateUserInfoInitial()) {
    on<UploadPicture>((event, emit) async {
      emit(UpdateUserLoading());
      try {
        String userImage = await  _userRepository.uploadPicture(event.file, event.userId) ;
        emit(UpdatePictureSuccess(userImage));
      } catch (e) {
        emit(UpdateUserInfoFailure());
        log(e.toString());
      }
    });

     on<UpdateMyUser>((event, emit) async {
      try {
        await _userRepository.updateUserData(event.userId, event.updates);
        MyUser updatedUser = await _userRepository.getMyUser(event.userId);
        emit(UpdateUserInfoSuccess(updatedUser));
      } catch (e) {
        log(e.toString());
        emit( UpdateUserInfoFailure());
        print(e.toString());
      }
    });
  }
}
