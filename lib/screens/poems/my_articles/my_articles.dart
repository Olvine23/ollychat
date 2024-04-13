import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:olly_chat/components/row_tile.dart';
import 'package:shimmer/shimmer.dart';

import '../../../blocs/get_post/get_post_bloc.dart';
import '../../home/widgets/shimmer_widget.dart';

class MyArticles extends StatelessWidget {
  const MyArticles({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search,size: 30.dp,))
        ],
        title:  Text("My Articles", style: Theme.of(context).textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.w900,
          fontSize: 24.dp
        )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
            
              padding:  EdgeInsets.symmetric(horizontal: 16.dp, vertical: 16.dp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("48 Articles", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w900),),
                  Row(
                    children: [
                      IconButton(onPressed: (){}, 
                      
                      icon: Icon(Icons.view_module_outlined)),
                      IconButton(onPressed: (){}, 
                      
                      icon: Icon(Icons.view_list))
              
                    ],
                  )
                ],
              ),
            ),
            BlocBuilder<GetPostBloc, GetPostState>(
              builder: (context, state) {
                if (state.status == GetPostStatus.success) {
                  log(state.posts!.length.toString());
                  return ListView.builder(
                    shrinkWrap: true, // Add this line
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.posts?.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(onTap: () {}, child: const RowTile());

                      // return Text(
                      //     '${state.posts[index].title} uploaded by ${state.posts[index].myUser.name}');
                    },
                  );
                } else if (state.status == GetPostStatus.unknown) {
                  return Shimmer.fromColors(
                      highlightColor: Colors.white54,
                      baseColor: const Color(0xffdedad7),
                      child: project_screen_shimmer(context));
                }

                return const Text("No data available"); // Handle other states
              },
            ),
          ],
        ),
      ),
    );
  }
}
