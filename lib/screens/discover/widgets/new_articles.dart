import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/components/row_tile.dart';
import 'package:olly_chat/screens/home/widgets/shimmer_widget.dart';
import 'package:olly_chat/screens/poems/poem_detail.dart';
import 'package:post_repository/post_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_repository/user_repository.dart';

class NewArticlesList extends StatelessWidget {
    final user = FirebaseAuth.instance.currentUser;
   NewArticlesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetPostBloc, GetPostState>(
      builder: (context, state) {
        if (state.status == GetPostStatus.success) {
           final List<Post> recentArticles =
          state.posts!.where((post) => post.myUser.id != user!.uid && post.isPrivate != true ).toList();
          return ListView.builder(
            shrinkWrap: true,
            cacheExtent: 1000,
            physics: const NeverScrollableScrollPhysics(),
            // itemCount: state.posts?.length ?? 0,
            itemCount:recentArticles.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Handle onTap
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BlocProvider<MyUserBloc>(
                      create: (context) => MyUserBloc(myUserRepository: FirebaseUserRepo()),
                      child: PoemDetailScreen(post: state.posts![index]),
                    );
                  }));
                },
                child: RowTile(
                  imageUrl: recentArticles[index].thumbnail!,
                  title:recentArticles[index].title,
                  userAvatar: recentArticles[index].myUser.image!,
                  authorName: recentArticles[index].myUser.name,
                  daysago: recentArticles[index].createdAt,
                ),
              );
            },
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
    );
  }
}
