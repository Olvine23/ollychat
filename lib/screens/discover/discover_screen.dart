import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:olly_chat/blocs/create_post/create_post_bloc.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/components/article_list_card.dart';
import 'package:olly_chat/components/row_tile.dart';
import 'package:olly_chat/screens/bookmarks/bookmark.dart';
import 'package:olly_chat/screens/discover/components/container_image.dart';
import 'package:olly_chat/screens/discover/components/discover_top_section.dart';
import 'package:olly_chat/screens/discover/components/image_text_stack.dart';
import 'package:olly_chat/screens/discover/components/writers_container.dart';
import 'package:olly_chat/screens/home/components/row_title.dart';
import 'package:olly_chat/screens/home/components/top_section.dart';
import 'package:olly_chat/screens/home/widgets/article_card.dart';
import 'package:olly_chat/screens/home/widgets/shimmer_widget.dart';
import 'package:olly_chat/screens/poems/poem_detail.dart';
import 'package:olly_chat/theme/colors.dart';
import 'package:shimmer/shimmer.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                'assets/images/nobg.png',
                height: 100,
              ),
              Text(
                "Discover",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
              )
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.dp),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return BookMarkScreen();
                    }));
                  },
                  icon: Icon(
                    Icons.bookmark_added_outlined,
                    size: 30.dp,
                    color: AppColors.secondaryColor,
                  )),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Padding(
            //   padding: EdgeInsets.only(right: 10.0, top: 10),
            //   child: DiscoverTopSection(),
            // ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20.dp),
                child: const TextField(
                  decoration: InputDecoration(
                    labelText: 'Search for article or writer',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                )),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const RowTitle(
                    text: 'Most Popular',
                  ),
                  InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.arrow_forward,
                        color: AppColors.secondaryColor,
                        size: 30,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2 - 70,
              child: BlocBuilder<GetPostBloc, GetPostState>(
                builder: (context, state) {
                  if (state.status == GetPostStatus.success) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        // itemCount: state.posts?.length,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return PoemDetailScreen(
                                  post: state.posts![index],
                                );
                              }));
                            },
                            child: ArticleCard(
                              
                              articleimg: state.posts![index].thumbnail!,
                              author: state.posts![index].myUser.name,
                              authorImg: state.posts![index].myUser.image!,
                              daysago: state.posts![index].createdAt,
                              title: state.posts![index].title,  
                               genre: state.posts![index].genre == null ? "Genre" : state.posts![index].genre!,
                            ),
                          );

                          // return Text(
                          //     '${state.posts[index].title} uploaded by ${state.posts[index].myUser.name}');
                        },
                      ),
                    );
                  } else if (state.status == GetPostStatus.unknown) {
                    return Shimmer.fromColors(
                        highlightColor: Colors.white54,
                        baseColor: const Color(0xffdedad7),
                        child: project_screen_shimmer(context));
                  }

                  return const Text("No data available"); // Handle other states
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const RowTitle(
                    text: 'Explore by topics',
                  ),
                  InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.arrow_forward,
                        color: AppColors.secondaryColor,
                        size: 30,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2 - 240,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ContainerImage(),
                    );
                  }),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const RowTitle(
                    text: 'Top Writers',
                  ),
                  InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.arrow_forward,
                        color: AppColors.secondaryColor,
                        size: 30,
                      )),
                ],
              ),
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height / 2 - 260,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return const WritersContainer();
                    })),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0.dp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const RowTitle(
                    text: 'Our Recommendations',
                  ),
                  InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.arrow_forward,
                        color: AppColors.secondaryColor,
                        size: 30,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2 - 70,
              child: BlocBuilder<GetPostBloc, GetPostState>(
                builder: (context, state) {
                  if (state.status == GetPostStatus.success) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        // itemCount: state.posts?.length,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return PoemDetailScreen(
                                  post: state.posts![index],
                                );
                              }));
                            },
                            child: ArticleCard(
                              genre: state.posts![index].genre == null ? "Genre" : state.posts![index].genre!,
                              articleimg: state.posts![index].thumbnail!,
                              author: state.posts![index].myUser.name,
                              authorImg: state.posts![index].myUser.image!,
                              daysago: state.posts![index].createdAt,
                              title: state.posts![index].title,
                            ),
                          );

                          // return Text(
                          //     '${state.posts[index].title} uploaded by ${state.posts[index].myUser.name}');
                        },
                      ),
                    );
                  } else if (state.status == GetPostStatus.unknown) {
                    return Shimmer.fromColors(
                        highlightColor: Colors.white54,
                        baseColor: const Color(0xffdedad7),
                        child: project_screen_shimmer(context));
                  }

                  return const Text("No data available"); // Handle other states
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const RowTitle(
                    text: 'New Articles',
                  ),
                  InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.arrow_forward,
                        color: AppColors.secondaryColor,
                        size: 30,
                      )),
                ],
              ),
            ),
            BlocBuilder<GetPostBloc, GetPostState>(
              builder: (context, state) {
                if (state.status == GetPostStatus.success) {
                  return ListView.builder(
                    shrinkWrap: true, // Add this line
                    physics:
                        const NeverScrollableScrollPhysics(), // Add this line
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Handle onTap
                        },
                        child: RowTile(
                          imageUrl: state.posts![index].thumbnail!,
                          title: state.posts![index].title,
                          userAvatar: state.posts![index].myUser.image!,
                          authorName: state.posts![index].myUser.name,
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
            ),
          ],
        )));
  }
}
