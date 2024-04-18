import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:lottie/lottie.dart';
import 'package:olly_chat/theme/colors.dart';

class RowTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String userAvatar;
  final String authorName;
  const RowTile({

    super.key, required this.imageUrl, required this.title, required this.userAvatar, required this.authorName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        child: Row(
          children: [
             Container(
                  height: 18.h,
                  width: 40.w,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        10.0), // Adjust the value as needed
                    child: CachedNetworkImage(
                      imageUrl: imageUrl ,
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
    
                SizedBox(width: 16.dp,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 18),),
                      SizedBox(height: 8,),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(userAvatar),
                                radius: 20,
                                backgroundColor: AppColors.primaryColor,
                               
                              ),
                              SizedBox(width: 4.dp,),
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
                      SizedBox(height: 8,),
                      Row(
                      
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("2 days ago"),
                          SizedBox(width: 12.dp,),
                          Container(
                            child: 
                            Row(
                             
                              children: [
                              Icon(Icons.bookmark),
                              IconButton(onPressed:() {}, icon:Icon(Icons.more_horiz))
                            ]),
                          )
                        ],
                      )
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
