import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/screens/home/widgets/article_card.dart';
import 'package:olly_chat/screens/home/widgets/shimmer_widget.dart';
import 'package:olly_chat/screens/poems/poem_detail.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_repository/user_repository.dart';

class PostList extends StatelessWidget {
  final ScrollController? scrollController;
  const PostList({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2 - 70,
      child: BlocBuilder<GetPostBloc, GetPostState>(
        builder: (context, state) {
          if (state.status == GetPostStatus.success) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                cacheExtent: 1000, // Prefetch items to smooth scrolling
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: state.posts!.length > 10 ? 10 : state.posts!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return BlocProvider<MyUserBloc>(
                          create: (context) => MyUserBloc(myUserRepository: FirebaseUserRepo()),
                          child: PoemDetailScreen(post: state.posts![index]),
                        );
                      }));
                    },
                    child: ArticleCard(
                      authorId: state.posts![index].myUser.id,
                      articleimg: state.posts![index].thumbnail!,
                      author: state.posts![index].myUser.name,
                      authorImg: state.posts![index].myUser.image!,
                      daysago: state.posts![index].createdAt,
                      title: state.posts![index].title,
                      genre: state.posts![index].genre ?? "Genre",
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
