import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/components/row_tile.dart';
import 'package:olly_chat/screens/poems/poem_detail.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_repository/user_repository.dart';

class BookMarkScreen extends StatelessWidget {
  const BookMarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyUserBloc(myUserRepository: FirebaseUserRepo())
        ..add(LoadBookmarkedPosts(FirebaseAuth.instance.currentUser!.uid)),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Bookmarks",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.w900, fontSize: 24.dp)),
        ),
        body: BlocBuilder<MyUserBloc, MyUserState>(builder: (context, state) {
          if (state.status == MyUserStatus.loading) {
            return ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                    ),
                    title: Container(
                      height: 20,
                      color: Colors.white,
                    ),
                    subtitle: Container(
                      height: 14,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            );
          } else if (state.status == MyUserStatus.success &&
              state.bookmarkedPosts != null &&
              state.bookmarkedPosts!.isNotEmpty) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.dp, vertical: 16.dp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${state.bookmarkedPosts!.length} Articles",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w900),
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.view_module_outlined)),
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.view_list))
                          ],
                        )
                      ],
                    ),
                  ),
                  ListView.builder(
                     physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.bookmarkedPosts!.length,
                    itemBuilder: (context, index) {
                      final post = state.bookmarkedPosts![index];
              
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return BlocProvider<MyUserBloc>(
                                create: (context) => MyUserBloc(myUserRepository: FirebaseUserRepo()),
                                child: PoemDetailScreen(
                                    post: state.bookmarkedPosts![index]),
                              );
                            }));
                          },
                          child: RowTile(
                            imageUrl: state.bookmarkedPosts![index].thumbnail!,
                            title: state.bookmarkedPosts![index].title,
                            userAvatar:
                                state.bookmarkedPosts![index].myUser.image!,
                            authorName: state.bookmarkedPosts![index].myUser.name,
                            daysago: state.bookmarkedPosts![index].createdAt,
                          ));
                      // return ListTile(
                      //   leading: CircleAvatar(
                      //     radius: 20,
                      //     backgroundImage: NetworkImage(post.thumbnail!),
                      //   ),
                      //   title: Text(post.title),
                      //   trailing: IconButton(
                      //     icon: Icon(Icons.delete, color: Colors.red),
                      //     onPressed: () {
                      //       BlocProvider.of<MyUserBloc>(context).add(
                      //         UnbookmarkPost(
                      //           FirebaseAuth.instance.currentUser!.uid,
                      //           post.id,
                      //         ),
                      //       );
                      //       BlocProvider.of<MyUserBloc>(context).add(LoadBookmarkedPosts(FirebaseAuth.instance.currentUser!.uid));
                      //     },
                      //   ),
                      // );
                    },
                  ),
                ],
              ),
            );
          } else if (state.status == MyUserStatus.success &&
              (state.bookmarkedPosts == null ||
                  state.bookmarkedPosts!.isEmpty)) {
            return Center(child: Text('No bookmarked posts found'));
          } else if (state.status == MyUserStatus.failure) {
            return Center(child: Text('Failed to load bookmarked posts'));
          } else {
            return Container();
          }
        }),
      ),
    );
  }
}
