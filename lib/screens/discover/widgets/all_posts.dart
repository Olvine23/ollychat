import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/components/article_list_card.dart';
import 'package:olly_chat/components/row_tile.dart';
import 'package:olly_chat/screens/home/widgets/article_card.dart';
import 'package:olly_chat/screens/home/widgets/shimmer_widget.dart';
import 'package:olly_chat/screens/poems/poem_detail.dart';
import 'package:shimmer/shimmer.dart';

class AllItemsScreen extends StatelessWidget {
  final ScrollController? scrollController;
  const AllItemsScreen({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              size: 30.dp,
            ),
          ),
        ],
        title: const Text('All Items'),
      ),
      body: BlocBuilder<GetPostBloc, GetPostState>(
        builder: (context, state) {
          if (state.status == GetPostStatus.success) {
            return CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return PoemDetailScreen(post: state.posts![index]);
                          }));
                        },
                        child: RowTile(
                          imageUrl: state.posts![index].thumbnail!,
                          title: state.posts![index].title,
                          userAvatar: state.posts![index].myUser.image!,
                          authorName: state.posts![index].myUser.name,
                        ),
                        // Uncomment if you want to use ArticleCard instead of RowTile
                        // child: ArticleCard(
                        //   authorId: state.posts![index].myUser.id,
                        //   articleimg: state.posts![index].thumbnail!,
                        //   author: state.posts![index].myUser.name,
                        //   authorImg: state.posts![index].myUser.image!,
                        //   daysago: state.posts![index].createdAt,
                        //   title: state.posts![index].title,
                        //   genre: state.posts![index].genre ?? "Genre",
                        // ),
                      );
                    },
                    childCount: state.posts!.length,
                  ),
                ),
              ],
            );
          } else if (state.status == GetPostStatus.unknown) {
            return Shimmer.fromColors(
              highlightColor: Colors.white54,
              baseColor: const Color(0xffdedad7),
              child: project_screen_shimmer(context),
            );
          }
          return const Text("No data available");
        },
      ),
    );
  }
}
