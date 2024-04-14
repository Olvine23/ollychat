part of 'get_post_bloc.dart';

sealed class GetPostEvent extends Equatable {
  const GetPostEvent();

  @override
  List<Object> get props => [];
}


class GetPosts extends GetPostEvent{
  
}

class FetchRecentArticles extends GetPostEvent {}

class FetchMyArticles extends GetPostEvent {}