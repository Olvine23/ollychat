import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:olly_chat/theme/colors.dart';
import 'package:post_repository/post_repository.dart';

class PoemDetailScreen extends StatelessWidget {

  final Post post;
  const PoemDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        iconTheme: IconThemeData(
          size: 30.dp,
          color: Colors.white),
        backgroundColor: Colors.transparent,
        actions: [
          Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Handle share icon tap
                      },
                      icon: Icon(Icons.share),
                      color: Colors.white,
                      iconSize: 30,
                    ),
                    IconButton(
                      onPressed: () {
                        // Handle favorite icon tap
                      },
                      icon: Icon(Icons.favorite),
                      color: Colors.white,
                      iconSize: 30,
                    ),
                    IconButton(
                      onPressed: () {
                        // Handle settings icon tap
                      },
                      icon: Icon(Icons.settings),
                      color: Colors.white,
                      iconSize: 30,
                    ),
                  ],
                ),

        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // 40% of our total height
              height: size.height * 0.4,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: size.height * 0.4 - 10,
                    decoration: BoxDecoration(
                      
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                         post.thumbnail!),
                      ),
                    ),
                  ),
 
                  // Rating Box
                  // Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   child: Container(
                  //     // it will cover 90% of our total width
                  //     width: size.width * 0.9,
                  //     height: 100,
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: const BorderRadius.only(
                  //         bottomLeft: Radius.circular(50),
                  //         topLeft: Radius.circular(50),
                  //       ),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           offset: const Offset(0, 5),
                  //           blurRadius: 50,
                  //           color: const Color(0xFF12153D).withOpacity(0.2),
                  //         ),
                  //       ],
                  //     ),
                  //     child: Padding(
                  //       padding:
                  //           const EdgeInsets.symmetric(horizontal: 16),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //         children: <Widget>[
                  //           Column(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: <Widget>[
                  //               const Icon(Icons.star ,color: Colors.yellow,),
                  //               const SizedBox(height: 16 / 4),
                  //               RichText(
                  //                 text: const TextSpan(
                  //                   style: TextStyle(color: Colors.black),
                  //                   children: [
                  //                     TextSpan(
                  //                       text: "5",
                  //                       style: TextStyle(
                  //                           fontSize: 16, fontWeight: FontWeight.w600),
                  //                     ),
                  //                     TextSpan(text: "10\n"),

                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           // Rate this
                  //           Column(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: <Widget>[
                  //               const Icon(Icons.star,),
                  //               const SizedBox(height: 16 / 4),
                  //               Text("Rate This",
                  //                   style: Theme.of(context).textTheme.bodyText2),
                  //             ],
                  //           ),
                  //           // Metascore
                  //           Column(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: <Widget>[
                  //               Container(
                  //                 padding: const EdgeInsets.all(6),
                  //                 decoration: BoxDecoration(
                  //                   color: const Color(0xFF51CF66),
                  //                   borderRadius: BorderRadius.circular(2),
                  //                 ),
                  //                 child: const Text(
                  //                   "5",
                  //                   style: TextStyle(
                  //                     fontSize: 16,
                  //                     color: Colors.white,
                  //                     fontWeight: FontWeight.w500,
                  //                   ),
                  //                 ),
                  //               ),
                  //               const SizedBox(height: 16 / 4),
                  //               const Text(
                  //                 "Metascore",
                  //                 style: TextStyle(
                  //                     fontSize: 16, fontWeight: FontWeight.w500),
                  //               ),
                  //               const Text(
                  //                 "62 critic reviews",
                  //                 style: TextStyle(color: Colors.white),
                  //               )
                  //             ],
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Back Button
                 
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
               
               post.title,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                     post.myUser.image!),
                backgroundColor: AppColors.primaryColor,
              ),
              title: Text(
                post.myUser.name,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w900),
              ),
              subtitle: const Text("@olly_poet"),
              trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.primaryColor),
                  onPressed: () {},
                  child: const Text("Follow")),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryColor),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Sorrowful',
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  const Text("8 hours ago"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(post.body!, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
            )
          ],
        ),
      ),
    );
  }
}
