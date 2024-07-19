part of 'myuser_bloc.dart';

enum MyUserStatus { success, loading, failure }

class MyUserState extends Equatable {
  final MyUserStatus status;
  final MyUser? user;
  final List<MyUser>? users;
   final List<Post>? bookmarkedPosts;

  const MyUserState._({
    this.status = MyUserStatus.loading,
    this.user,
    this.users,
    this.bookmarkedPosts
  });

  const MyUserState.loading() : this._();

  const MyUserState.success(MyUser user) : this._(status: MyUserStatus.success, user: user);

  const MyUserState.usersSuccess(List<MyUser> users) : this._(status: MyUserStatus.success, users: users);

  const MyUserState.failure() : this._(status: MyUserStatus.failure);

    const MyUserState.bookmarkedPostsSuccess(List<Post> bookmarkedPosts)
      : this._(status: MyUserStatus.success, bookmarkedPosts: bookmarkedPosts);

  @override
  List<Object?> get props => [status, user, users, bookmarkedPosts];
}
