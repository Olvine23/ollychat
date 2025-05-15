import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/screens/home/widgets/article_card.dart';
import 'package:olly_chat/screens/home/widgets/shimmer_widget.dart';
import 'package:olly_chat/screens/poems/poem_detail.dart';
import 'package:post_repository/post_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_repository/user_repository.dart';

class PostList extends StatelessWidget {
    final user = FirebaseAuth.instance.currentUser;
  final ScrollController? scrollController;
   PostList({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2 - 70,
      child: BlocBuilder<GetPostBloc, GetPostState>(
        builder: (context, state) {
          if (state.status == GetPostStatus.success) {
               final List<Post> recentArticles =
          state.posts!.where((post) => post.myUser.id != user!.uid && post.isPrivate != true ).toList();
          print("Recent Articles: ${recentArticles.length}");
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                cacheExtent: 1000, // Prefetch items to smooth scrolling
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: recentArticles.length ,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return BlocProvider<MyUserBloc>(
                          create: (context) => MyUserBloc(myUserRepository: FirebaseUserRepo()),
                          child: PoemDetailScreen(post: recentArticles[index]),
                        );
                      }));
                    },
                    child: ArticleCard(
                      authorId: recentArticles[index].myUser.id,
                      articleimg: recentArticles[index].thumbnail!,
                      author: recentArticles[index].myUser.name,
                      authorImg: recentArticles[index].myUser.image!,
                      daysago: recentArticles[index].createdAt,
                      title: recentArticles[index].title,
                      genre: recentArticles[index].genre ?? "Genre",
                    ),
                  );
                },
              ),
            );
          } else if (state.status == GetPostStatus.unknown) {
            return Shimmer.fromColors(
              highlightColor: Colors.white54,
              baseColor: const Color(0xffdedad7),
              child: project_screen_shimmer(context),
            );
          }
          return const Text("No data available"); // Handle other states
        },
      ),
    );
  }
}
