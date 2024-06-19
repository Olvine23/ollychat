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

class LoadMorePosts extends GetPostEvent {

  final int pageKey;
  const LoadMorePosts({required this.pageKey});

   @override
  List<Object> get props => [pageKey];
}
class GetPostsByCategory extends GetPostEvent {
  final String category;
  final int pageKey;

  const GetPostsByCategory({required this.category, required this.pageKey});

  @override
  List<Object> get props => [category, pageKey];
}
class FetchMyArticles extends GetPostEvent {}