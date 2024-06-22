import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:lottie/lottie.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/components/row_tile.dart';
import 'package:olly_chat/screens/discover/components/container_image.dart';
import 'package:olly_chat/screens/discover/components/head_image.dart';
import 'package:post_repository/post_repository.dart';

class CategoryPostsScreen extends StatelessWidget {
  final String category;
  final String headImage;

  const CategoryPostsScreen({Key? key, required this.category, required this.headImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetPostBloc(postRepository: FirebasePostRepository())
        ..add(GetPostsByCategory(category: category, pageKey: 1)),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white
          ),
backgroundColor: Colors.transparent,
          title: Text(category,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900, fontSize: 24.dp)),
        ),
        body: BlocBuilder<GetPostBloc, GetPostState>(
          builder: (context, state) {
            if (state.status == GetPostStatus.failure) {
              return Center(child: Text('Failed to fetch posts'));
            }
            if (state.status == GetPostStatus.success) {
              if (state.posts!.isEmpty) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/lotti/nothing.json', repeat: false),
                    Text(
                      'No posts for this category',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ));
              }
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 200), // Height of the fixed head image
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //       horizontal: 16.dp),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         "${state.posts!.length} Articles",
                        //         style: Theme.of(context)
                        //             .textTheme
                        //             .bodyLarge!
                        //             .copyWith(fontWeight: FontWeight.w900),
                        //       ),
                        //       Row(
                        //         children: [
                        //           IconButton(
                        //               onPressed: () {},
                        //               icon: Icon(Icons.view_module_outlined)),
                        //           IconButton(
                        //               onPressed: () {}, icon: Icon(Icons.view_list))
                        //         ],
                        //       )
                        //     ],
                        //   ),
                        // ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.posts!.length,
                          itemBuilder: (context, index) {
                            final post = state.posts![index];
                            return RowTile(
                                imageUrl: post.thumbnail!,
                                title: post.title,
                                userAvatar: post.myUser.image!,
                                authorName: post.myUser.name,
                                daysago: post.createdAt);
                          },
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: HeadImage(
                        categ: category,
                        image: headImage,
                        stateCount: state.posts!.length,
                        
                        
                        ),
                  ),
                ],
              );
            }
            return Center(child: Lottie.asset('assets/lotti/creating.json'));
          },
        ),
      ),
    );
  }
}
