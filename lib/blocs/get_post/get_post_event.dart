part of 'get_post_bloc.dart';

sealed class GetPostEvent extends Equatable {
  const GetPostEvent();

  @override
  List<Object> get props => [];
}


class GetPosts extends GetPostEvent{
 final int pageKey; // Add this field

  const GetPosts({this.pageKey = 1}); // Update constructor to accept an optional page key
  
}

class FetchRecentArticles extends GetPostEvent {}

class FetchMyArticles extends GetPostEvent {}