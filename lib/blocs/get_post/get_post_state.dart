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
  GetPostState({this.status = GetPostStatus.unknown, this.posts});

  GetPostState.unkonwn() : this();

  GetPostState.success(List<Post> posts)
      : this(status: GetPostStatus.success, posts: posts);

  GetPostState.failure()
      : this(status: GetPostStatus.failure);

  final GetPostStatus status;
  List<Post>? posts;

  GetPostState copyWith({
    GetPostStatus? status,
    List<Post>? posts,
  }) {
    return GetPostState(
        status: status ?? this.status, posts: posts ?? this.posts);
  }

  @override
  List<Object?> get props => [status, posts];
}
