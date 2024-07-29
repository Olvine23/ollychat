import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:lottie/lottie.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/blocs/updateuserinfo/update_user_info_bloc.dart';
import 'package:olly_chat/screens/profile/profile_screen.dart';
import 'package:olly_chat/theme/colors.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';

import '../components/image_container.dart';

class ArticleCard extends StatelessWidget {
  final String articleimg;
  final String authorId;
  final String author;
  final String authorImg;
  final DateTime daysago;
  final String title;
  final String genre;

  const ArticleCard({
    super.key,
    required this.articleimg,
    required this.author,
    required this.authorImg,
    required this.daysago,
    required this.title,
    required this.genre,
    required this.authorId,
  });

 String formatTimeAgo(DateTime timestamp) {
  Duration difference = DateTime.now().difference(timestamp);

  if (difference.inDays >= 365) {
    int years = difference.inDays ~/ 365;
    return '$years ${years == 1 ? 'year ago' : 'years ago'}';
  } else if (difference.inDays >= 30) {
    int months = difference.inDays ~/ 30;
    return '$months ${months == 1 ? 'month ago' : 'months ago'}';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} ${difference.inDays == 1 ? 'day ago' : 'days ago'}';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} ${difference.inHours == 1 ? 'hour ago' : 'hours ago'}';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute ago' : 'minutes ago'}';
  } else {
    return 'just now';
  }
}


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          margin: const EdgeInsets.only(right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30.2.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 25.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            memCacheHeight: 500,
                            memCacheWidth: 500,
                            imageUrl: articleimg,
                            placeholder: (context, url) => Center(
                                child: Lottie.asset('assets/lotti/imageload.json')),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black,
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 10,
                            left: 16,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2.0, horizontal: 12.0),
                                  child: Text(
                                    genre,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )))
                      ]),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 4.0.h,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider<UpdateUserInfoBloc>(
                          create: (context) => UpdateUserInfoBloc(
                              userRepository: FirebaseUserRepo(),
                              postRepository: FirebasePostRepository()),
                        ),
                        BlocProvider<MyUserBloc>(
                          create: (context) => MyUserBloc(myUserRepository: FirebaseUserRepo()),
                        ),
                      ],
                      child: ProfileScreen(
                        userId: authorId, toggleTheme: (ThemeMode ) {  },
                      ),
                    );
                  }));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primaryColor,
                      backgroundImage: NetworkImage(authorImg == ''
                          ? 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png'
                          : authorImg),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 0.8.h),
                        child: Text(
                          author,
                          textAlign: TextAlign.justify,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: AppColors.secondaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        formatTimeAgo(daysago),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontWeight: FontWeight.bold, fontSize: 10.dp),
                      ),
                    ))
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 2.w,)
      ],
    );
  }
}
