// ignore_for_file: must_be_immutable

part of 'get_post_bloc.dart';

enum GetPostStatus { success, failure, unknown }

class GetPostState extends Equatable {
  final GetPostStatus status;
  final List<Post>? posts;
  final List<Post>? searchResults;
  final int pageKey;

  GetPostState({
    this.status = GetPostStatus.unknown,
    this.posts,
    this.searchResults,
    this.pageKey = 0,
  });

  GetPostState.unknown() : this();

  GetPostState.success(List<Post> posts, {int pageKey = 0})
      : this(status: GetPostStatus.success, posts: posts, pageKey: pageKey);

  GetPostState.failure() : this(status: GetPostStatus.failure);

  GetPostState copyWith({
    GetPostStatus? status,
    List<Post>? posts,
    List<Post>? searchResults,
    int? pageKey,
  }) {
    return GetPostState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      searchResults: searchResults ?? this.searchResults,
      pageKey: pageKey ?? this.pageKey,
    );
  }

  @override
  List<Object?> get props => [status, posts, searchResults, pageKey];
}
