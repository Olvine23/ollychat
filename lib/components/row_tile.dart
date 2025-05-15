import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:lottie/lottie.dart';
import 'package:olly_chat/theme/colors.dart';

class RowTile extends StatelessWidget {
  final String imageUrl;
  final String title;
   final DateTime daysago;
   bool? isPrivate;
  final String userAvatar;
  final String authorName;
   RowTile({
    super.key,
    this.isPrivate,
    required this.imageUrl,
    required this.title,
    required this.userAvatar,
    required this.authorName, required this.daysago,
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
    return Column(
      children: [
        Padding(
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
                          backgroundImage: NetworkImage(userAvatar == "" ? "https://img.freepik.com/free-psd/contact-icon-illustration-isolated_23-2151903337.jpg?semt=ais_hybrid&w=740" : userAvatar),
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
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h,)
      ],
    );
  }
}
