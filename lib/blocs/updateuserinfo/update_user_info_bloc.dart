import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'update_user_info_event.dart';
part 'update_user_info_state.dart';

class UpdateUserInfoBloc extends Bloc<UpdateUserInfoEvent, UpdateUserInfoState> {
  final UserRepository _userRepository;
  final PostRepository _postRepository;

  UpdateUserInfoBloc({required UserRepository userRepository, required PostRepository postRepository})
      : _userRepository = userRepository,
        _postRepository = postRepository,
        super(UpdateUserInfoInitial()) {
    
    on<UploadPicture>((event, emit) async {
      emit(UpdateUserLoading());
      try {
        String userImage = await _userRepository.uploadPicture(event.file, event.userId);
        emit(UpdatePictureSuccess(userImage));
      } catch (e) {
        emit(UpdateUserInfoFailure());
        log(e.toString());
      }
    });

    on<UpdateMyUser>((event, emit) async {
      emit(UpdateUserLoading());
      try {
        // Update user data
        await _userRepository.updateUserData(event.userId, event.updates);

        // Fetch the updated user data
        MyUser updatedUser = await _userRepository.getMyUser(event.userId);

        // Update all posts with the updated user information
        await _postRepository.updateAllPostsForUser(updatedUser);

        emit(UpdateUserInfoSuccess(updatedUser));
      } catch (e) {
        log(e.toString());
        emit(UpdateUserInfoFailure());
        print(e.toString());
      }
    });
  }
}