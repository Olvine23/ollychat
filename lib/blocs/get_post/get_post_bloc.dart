import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:post_repository/post_repository.dart';

part 'get_post_event.dart';
part 'get_post_state.dart';

 class GetPostBloc extends Bloc<GetPostEvent, GetPostState> {
  PostRepository _postRepository;

  GetPostBloc({required PostRepository postRepository})
      : _postRepository = postRepository,
        super(GetPostState.unkonwn()) {
    on<GetPosts>((event, emit) async {
      // Handle the GetPosts event here
     
      try {
         List<Post> posts = await _postRepository.getPost();
         emit(GetPostState.success(posts));
      } catch (_) {
        emit(GetPostState.failure());
      }
    });
  }
}
