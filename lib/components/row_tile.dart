import 'package:cached_network_image/cached_network_image.dart';
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

class RowTile extends StatelessWidget {
  final String authorId;
  final String imageUrl;
  final String title;
   final DateTime daysago;
  final String userAvatar;
  final String authorName;
  const RowTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.userAvatar,
    required this.authorName, required this.authorId, required this.daysago,
  });

    String formatTimeAgo(DateTime timestamp) {
    Duration difference = DateTime.now().difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            height: 18.h,
            width: 40.w,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(10.0), // Adjust the value as needed
              child: CachedNetworkImage(
                memCacheHeight: 500,
                memCacheWidth: 500,
                imageUrl: imageUrl == '' ? 'https://png.pngtree.com/png-vector/20190820/ourmid/pngtree-no-image-vector-illustration-isolated-png-image_1694547.jpg' : imageUrl ,
                placeholder: (context, url) =>
                    Center(child: Lottie.asset('assets/lotti/imageload.json')),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Container(
          //     height: 120,
          //     width: 150,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(20),
          //         image: DecorationImage(
          //             image: NetworkImage(
          //                  imageUrl),
          //             fit: BoxFit.cover)),
          //     child: Container(
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(20),
          //           ),
          //     )),

          SizedBox(
            width: 16.dp,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                     Expanded(
                       child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                       
                          children: [
                            Icon(Icons.favorite, color: Colors.red,),
                            SizedBox(width: 1.4.w,),
                            Text("999 likes", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: AppColors.secondaryColor)
                            ,)
                          ],
                        ),
                     )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: (){
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
                    userId: authorId,
                  ),
                );
              }));
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(userAvatar == ''
                            ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/2048px-User-avatar.svg.png'
                            : userAvatar),
                        radius: 20,
                        backgroundColor: AppColors.white,
                      ),
                      SizedBox(
                        width: 4.dp,
                      ),
                      Expanded(
                        child: Text(
                          authorName,
                          textAlign: TextAlign.justify,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: AppColors.secondaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text( formatTimeAgo(daysago),),
                   
                    Icon(Icons.bookmark, color: AppColors.secondaryColor,)
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
