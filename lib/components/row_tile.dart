import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:lottie/lottie.dart';
import 'package:olly_chat/theme/colors.dart';

class RowTile extends StatelessWidget {
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
    required this.authorName, required this.daysago,
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
                imageUrl: imageUrl,
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
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(userAvatar),
                      radius: 20,
                      backgroundColor: AppColors.primaryColor,
                    ),
                    SizedBox(
                      width: 4.dp,
                    ),
                    Text(
                      authorName,
                      textAlign: TextAlign.justify,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(
                            color: AppColors.secondaryColor,
                            fontWeight: FontWeight.bold),
                    ),
                  ],
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
