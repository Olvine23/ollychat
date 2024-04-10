import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/screens/discover/components/image_text_stack.dart';
import 'package:olly_chat/screens/home/components/greetings.dart';
import 'package:olly_chat/screens/home/components/recent_articles.dart';
import 'package:olly_chat/screens/home/components/row_title.dart';
import 'package:olly_chat/screens/home/components/top-card.dart';
import 'package:olly_chat/screens/home/components/top_section.dart';
import 'package:olly_chat/screens/home/widgets/article_card.dart';
import 'package:olly_chat/screens/home/widgets/shimmer_widget.dart';
import 'package:olly_chat/screens/poems/poem_detail.dart';
import 'package:olly_chat/theme/colors.dart';
import 'package:shimmer/shimmer.dart';

class MainHome extends StatelessWidget {
  MainHome({super.key});

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // BlocProvider.of<GetPostBloc>(context).add(GetPosts());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 20.0, top: 10),
              child: TopSection(),
            ),
            // BlocBuilder<MyUserBloc, MyUserState>(
            //   builder: (context, state) {
            //     if (state.status == MyUserStatus.success) {
            //       return Greetings(name: state.user!.name);
            //     } else {
            //       return Text("data");
            //     }
            //   },
            // ),

          const Padding(
             padding:  EdgeInsets.symmetric(horizontal: 16.0),
             child:TopCard(),
           ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const RowTitle(
                    text: 'Recent Articles',
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
              height: MediaQuery.of(context).size.height / 2 - 90,
              child: BlocBuilder<GetPostBloc, GetPostState>(
                builder: (context, state) {
                  if (state.status == GetPostStatus.success) {
                    log(state.posts!.length.toString());
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.posts!.length,
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
                              daysago: '3 days ago',
                              title: state.posts![index].title,
                            ),
                          );

                          // return Text(
                          //     '${state.posts[index].title} uploaded by ${state.posts[index].myUser.name}');
                        },
                      ),
                    );
                  } else if(state.status ==  GetPostStatus.unknown){
              return Shimmer.fromColors(
                          highlightColor: Colors.white54,
                          baseColor: const Color(0xffdedad7),
                          child: project_screen_shimmer(context));
                  }

                  return Text("No data available"); // Handle other states
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
                    text: 'Your Articles',
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
              height: MediaQuery.of(context).size.height / 2 - 90,
              child: BlocBuilder<GetPostBloc, GetPostState>(
                builder: (context, state) {
                  if (state.status ==  GetPostStatus.success) {
                    log(state.posts!.length.toString());
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.posts!.length,
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
                              articleimg:  state.posts![index].thumbnail!,
                              author: state.posts![index].myUser.name,
                              authorImg: state.posts![index].myUser.image!,
                              daysago: '3 days ago',
                              title: state.posts![index].title,
                            ),
                          );

                          // return Text(
                          //     '${state.posts[index].title} uploaded by ${state.posts[index].myUser.name}');
                        },
                      ),
                    );
                  }

                  else if (state.status == GetPostStatus.unknown){
                    return Container(child: Text("Loading"),);
                  }

                  return Text("No data available"); // Handle other states
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
                    text: 'On Your Bookmark',
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
              height: MediaQuery.of(context).size.height / 2 - 90,
              child: BlocBuilder<GetPostBloc, GetPostState>(
                builder: (context, state) {
                  if (state.status ==  GetPostStatus.success) {
                    log(state.posts!.length.toString());
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.posts!.length,
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
                              articleimg:  state.posts![index].thumbnail!,
                              author: state.posts![index].myUser.name,
                              authorImg: state.posts![index].myUser.image!,
                              daysago: '3 days ago',
                              title: state.posts![index].title,
                            ),
                          );

                          // return Text(
                          //     '${state.posts[index].title} uploaded by ${state.posts[index].myUser.name}');
                        },
                      ),
                    );
                  }

                  else if (state.status == GetPostStatus.unknown){
                    return Container(child: Text("Loading"),);
                  }

                  return Text("No data available"); // Handle other states
                },
              ),
            ),

          
          ],
        ),
      ),
    );
  }
}
