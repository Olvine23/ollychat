import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/screens/home/components/row_title.dart';
import 'package:olly_chat/screens/home/components/top-card.dart';
import 'package:olly_chat/screens/home/components/top_section.dart';
import 'package:olly_chat/screens/home/recentarticles/recent_articles.dart';
import 'package:olly_chat/screens/home/widgets/article_card.dart';
import 'package:olly_chat/screens/home/widgets/shimmer_widget.dart';
import 'package:olly_chat/screens/poems/my_articles/my_articles.dart';
import 'package:olly_chat/screens/poems/poem_detail.dart';
import 'package:olly_chat/theme/colors.dart';
import 'package:post_repository/post_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_repository/user_repository.dart';

class MainHome extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  MainHome({super.key});

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    print(user!.uid);
    return Scaffold(
      body: BlocBuilder<GetPostBloc, GetPostState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<GetPostBloc>(context).add(GetPosts());
              return await Future.delayed(Duration(seconds: 2));
            },
            child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 20.0, top: 10),
                      child: TopSection(),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: TopCard(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: _buildPostList(context, state),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }

  Widget _buildPostList(BuildContext context, GetPostState state) {
    if (state.status == GetPostStatus.success) {
      final List<Post> myArticles =
          state.posts!.where((post) => post.myUser.id == user!.uid).toList();

      final List<Post> recentArticles =
          state.posts!.where((post) => post.myUser.id != user!.uid).toList();

      return Column(
        children: [
          _buildArticleSection(context, 'Recent Articles', recentArticles),
          _buildArticleSection(context, 'My Articles', myArticles),
        ],
      );
    } else if (state.status == GetPostStatus.unknown) {
      return Shimmer.fromColors(
        highlightColor: Colors.white54,
        baseColor: const Color(0xffdedad7),
        child: project_screen_shimmer(context),
      );
    }
    return Text("No data available"); // Handle other states
  }

  Widget _buildArticleSection(
      BuildContext context, String title, List<Post> articles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RowTitle(
                text: title,
              ),
              InkWell(
                onTap: () {
                  if (title == "Recent Articles") {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RecentArticles(posts: articles);
                    }));
                  } else if (title == "My Articles") {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MyArticles(posts: articles);
                    }));
                  }
                },
                child: Icon(
                  Icons.arrow_forward,
                  color: AppColors.secondaryColor,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2 - 70,
          child: articles.isEmpty
              ? Center(
                  child: Column(
                  children: [
                    Lottie.asset(
                      'assets/lotti/nothing.json',
                      repeat: false,
                    ),
                    Text(
                      "Nothing yet",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                  ],
                ))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PoemDetailScreen(post: articles[index])),
                        );
                      },
                      child: ArticleCard(
                        articleimg: articles[index].thumbnail!,
                        author: articles[index].myUser.name,
                        authorImg: articles[index].myUser.image!,
                        daysago: articles[index].createdAt,
                        title: articles[index].title,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
