import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:olly_chat/components/row_tile.dart';
import 'package:olly_chat/screens/poems/poem_detail.dart';
import 'package:post_repository/post_repository.dart';

class MyArticles extends StatelessWidget {
  final List<Post> posts;
  const MyArticles({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    print(posts.length);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                size: 30.dp,
              ))
        ],
        title: Text("My Articles ${posts.length}",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w900, fontSize: 24.dp)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.dp, vertical: 16.dp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "48 Articles",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w900),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.view_module_outlined)),
                      IconButton(onPressed: () {}, icon: Icon(Icons.view_list))
                    ],
                  )
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true, // Add this line
              physics: const NeverScrollableScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return GestureDetector(onTap: () {}, child:  RowTile(imageUrl: posts[index].thumbnail!, title: posts[index].title, userAvatar: posts[index].myUser.image!, authorName: posts[index].myUser.name, daysago: posts[index].createdAt,));

                // return Text(
                //     '${state.posts[index].title} uploaded by ${state.posts[index].myUser.name}');
              },
            )
          ],
        ),
      ),
    );
  }
}
