// ignore_for_file: must_be_immutable

part of 'get_post_bloc.dart';

// sealed class GetPostState extends Equatable {
//   const GetPostState(

//   );

//   @override
//   List<Object> get props => [];
// }

// final class GetPostInitial extends GetPostState {}

// final class GetPostFailure extends GetPostState {}
// final class GetPostLoading extends GetPostState {}
// final class GetPostSuccess extends GetPostState {
// 	final List<Post> posts;

// 	const GetPostSuccess(this.posts);
// }

enum GetPostStatus { success, failure, unknown }

class GetPostState extends Equatable {
  GetPostState({this.status = GetPostStatus.unknown,this.searchResults, this.posts, this.pageKey=0});

  GetPostState.unkonwn() : this();

  GetPostState.success(List<Post> posts, {int pageKey = 0})
      : this(status: GetPostStatus.success, posts: posts, pageKey: pageKey);

  GetPostState.failure()
      : this(status: GetPostStatus.failure);

  final GetPostStatus status;
  List<Post>? posts;
  final int pageKey;
  

  final List<Post>? searchResults;

  GetPostState copyWith({
    GetPostStatus? status,
    List<Post>? posts,
    
  
  }) {
    return GetPostState(
        status: status ?? this.status, posts: posts ?? this.posts, pageKey: pageKey);
  }

  @override
  List<Object?> get props => [status, posts , pageKey];
}
