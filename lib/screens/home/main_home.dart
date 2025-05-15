import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:lottie/lottie.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/screens/bookmarks/bookmark.dart';
import 'package:olly_chat/screens/home/components/home_carousel.dart';
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

import '../notifications/notification_screen.dart';

class MainHome extends StatefulWidget {
  final Function(ThemeMode) toggleTheme;

  const MainHome({super.key, required this.toggleTheme});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  final user = FirebaseAuth.instance.currentUser;

  final List<String> quotes = [
    "Your voice is a bridge — not a burden.",
    "It’s okay to not have it all figured out.",
    "Speak, even if it trembles. That’s still brave.",
    "Your feelings are valid, even if they don’t have words yet.",
    "Someone out there needs to hear your truth.",
    "Expression is the first step to healing.",
    "When you speak your truth, you give others permission to do the same."
  ];

  String getRandomQuote() {
    final random = Random();
    return quotes[random.nextInt(quotes.length)];
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    print(user!.uid);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "VoiceHub",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        leading: Image.asset('assets/images/nobg.png', height: 150),
        actions: [
          Icon(Icons.record_voice_over),
          //  Switch(
          //   value: isDarkMode,
          //   onChanged: (bool value) {

          //      print('Switch toggled: $value');
          //     value
          //         ? widget.toggleTheme(ThemeMode.dark)
          //         : widget.toggleTheme(ThemeMode.light);
          //   },
          // ),
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BlocProvider<MyUserBloc>(
                    create: (context) =>
                        MyUserBloc(myUserRepository: FirebaseUserRepo()),
                    child: const BookMarkScreen(),
                  );
                }));
              },
              icon: Icon(
                Icons.bookmark,
                size: 30,
                color: AppColors.secondaryColor,
              )),
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const NotificationScreen();
                }));
              },
              icon: Icon(
                Icons.notifications_outlined,
                size: 30,
                color: AppColors.secondaryColor,
              )),
        ],
      ),
      body: BlocBuilder<GetPostBloc, GetPostState>(
        builder: (context, state) {
          final List<Post> shuffledPosts = (state.posts ?? []).toList()
            ..shuffle();
          final Post? randomPost =
              shuffledPosts.isNotEmpty ? shuffledPosts.first : null;

          return RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<GetPostBloc>(context).add(const GetPosts());
              return await Future.delayed(const Duration(seconds: 2));
            },
            child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //                    Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16.0,),
                    //   child: HomeCarousel(posts: state.posts!),
                    // ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12),
                        BlocBuilder<MyUserBloc, MyUserState>(
                          builder: (context, state) {
                            if (state.status == MyUserStatus.loading) {
                              return const CircularProgressIndicator();
                            } else if (state.status == MyUserStatus.failure) {
                              return const Text("Error loading user data");
                            } else if (state.status == MyUserStatus.success) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  'Welcome back, ${state.user!.name} 👋',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }
                            return const Text("No data available");
                          },
                        ),
                        SizedBox(height: 4),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context)
                                  .size
                                  .width, // Prevents overflow
                            ),
                            child: Text(
                              getRandomQuote(),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Our pick for you",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    const SizedBox(height: 10),

                    if (state.status == GetPostStatus.success &&
                        state.posts!.isNotEmpty &&
                        randomPost != null)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return BlocProvider<MyUserBloc>(
                                  create: (context) => MyUserBloc(
                                      myUserRepository: FirebaseUserRepo()),
                                  child: PoemDetailScreen(post: randomPost),
                                );
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                final slideTween = Tween<Offset>(
                                    begin: Offset(0.0, 0.1), end: Offset.zero);
                                final fadeTween =
                                    Tween<double>(begin: 0.0, end: 1.0);

                                return SlideTransition(
                                  position: animation
                                      .drive(CurveTween(curve: Curves.easeOut))
                                      .drive(slideTween),
                                  child: FadeTransition(
                                    opacity: animation
                                        .drive(CurveTween(curve: Curves.easeIn))
                                        .drive(fadeTween),
                                    child: child,
                                  ),
                                );
                              },
                              transitionDuration: Duration(milliseconds: 500),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: TopCard(
                            post: randomPost,
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return BlocProvider<MyUserBloc>(
                                      create: (context) => MyUserBloc(
                                          myUserRepository: FirebaseUserRepo()),
                                      child: PoemDetailScreen(post: randomPost),
                                    );
                                  },
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    final slideTween = Tween<Offset>(
                                        begin: Offset(0.0, 0.1),
                                        end: Offset.zero);
                                    final fadeTween =
                                        Tween<double>(begin: 0.0, end: 1.0);

                                    return SlideTransition(
                                      position: animation
                                          .drive(
                                              CurveTween(curve: Curves.easeOut))
                                          .drive(slideTween),
                                      child: FadeTransition(
                                        opacity: animation
                                            .drive(CurveTween(
                                                curve: Curves.easeIn))
                                            .drive(fadeTween),
                                        child: child,
                                      ),
                                    );
                                  },
                                  transitionDuration:
                                      Duration(milliseconds: 500),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              "No posts available at the moment.",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                        ),
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
      final List<Post> recentArticles = state.posts!
          .where(
              (post) => post.myUser.id != user!.uid && post.isPrivate != true)
          .toList();

      final List<Post> privateArticles = state.posts!
          .where(
              (post) => post.myUser.id == user!.uid && post.isPrivate == true)
          .toList();

      print(privateArticles.length);

      return Column(
        children: [
          _buildArticleSection(context, 'Recent Articles', recentArticles),
          // SizedBox(
          //   height: 0.5.h,
          // ),
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
    return const Text("No data available"); // Handle other states
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
          height: 2.h,
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
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
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
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return BlocProvider<MyUserBloc>(
                                create: (context) => MyUserBloc(
                                    myUserRepository: FirebaseUserRepo()),
                                child: PoemDetailScreen(post: articles[index]),
                              );
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              final slideTween = Tween<Offset>(
                                  begin: Offset(0.0, 0.1), end: Offset.zero);
                              final fadeTween =
                                  Tween<double>(begin: 0.0, end: 1.0);

                              return SlideTransition(
                                position: animation
                                    .drive(CurveTween(curve: Curves.easeOut))
                                    .drive(slideTween),
                                child: FadeTransition(
                                  opacity: animation
                                      .drive(CurveTween(curve: Curves.easeIn))
                                      .drive(fadeTween),
                                  child: child,
                                ),
                              );
                            },
                            transitionDuration: Duration(milliseconds: 500),
                          ),
                        );
                      },
                      child: ArticleCard(
                        genre: articles[index].genre == null
                            ? "Genre"
                            : articles[index].genre!,
                        articleimg: articles[index].thumbnail!,
                        author: articles[index].myUser.name,
                        authorImg: articles[index].myUser.image!,
                        daysago: articles[index].createdAt,
                        title: articles[index].title,
                        authorId: articles[index].myUser.id,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
