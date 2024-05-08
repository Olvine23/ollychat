import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:lottie/lottie.dart';
import 'package:olly_chat/theme/colors.dart';

import '../components/image_container.dart';

class ArticleCard extends StatelessWidget {
  final String articleimg;
  final String author;
  final String authorImg;
  final String daysago;
  final String title;

  const ArticleCard({
    super.key,
    required this.articleimg,
    required this.author,
    required this.authorImg,
    required this.daysago,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        8.0), // Adjust the value as needed
                    child: CachedNetworkImage(
                      imageUrl: articleimg ,
                      placeholder: (context, url) =>
                          Center(child: Lottie.asset('assets/lotti/imageload.json')),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // ImageContainer(
                //     imageUrl:
                //         articleimg

                //         ),
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
            onTap: () {},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primaryColor,
                  backgroundImage: NetworkImage(authorImg == '' ? 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png':authorImg),
                ),
                SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.8.h),
                    child: Text(
                      author,
                      textAlign: TextAlign.justify,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    daysago,
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
    );
  }
}
