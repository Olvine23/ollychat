import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/components/row_tile.dart';
import 'package:olly_chat/screens/home/widgets/shimmer_widget.dart';
import 'package:olly_chat/screens/poems/poem_detail.dart';
import 'package:shimmer/shimmer.dart';

class NewArticlesList extends StatelessWidget {
  const NewArticlesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetPostBloc, GetPostState>(
      builder: (context, state) {
        if (state.status == GetPostStatus.success) {
          return ListView.builder(
            shrinkWrap: true,
            cacheExtent: 1000,
            physics: const NeverScrollableScrollPhysics(),
            // itemCount: state.posts?.length ?? 0,
            itemCount: 10,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Handle onTap
                  Navigator.push(context, MaterialPageRoute(builder: (context){

                    return PoemDetailScreen(post: state.posts![index]);
                  }));
                },
                child: RowTile(
                  imageUrl: state.posts![index].thumbnail!,
                  title: state.posts![index].title,
                  userAvatar: state.posts![index].myUser.image!,
                  authorName: state.posts![index].myUser.name, daysago: state.posts![index].createdAt,
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
