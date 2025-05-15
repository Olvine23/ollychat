import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/screens/discover/components/container_image.dart';
import 'package:olly_chat/screens/discover/screens/categories.dart';
import 'package:olly_chat/screens/discover/screens/categories_posts_screen.dart';
import 'package:olly_chat/screens/discover/widgets/topic_list.dart';
import 'package:post_repository/post_repository.dart';

class CategoryListScreen extends StatelessWidget {
  CategoryListScreen({super.key});

 final List<Category> categories = [
    Category(
        name:"Healing",
        imagePath:
            'https://images.unsplash.com/photo-1578048421563-9aa187e12baf?q=80&w=1960&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
    Category(
        name:  "Heartbreak",
        imagePath:
            'https://images.unsplash.com/photo-1516822003754-cca485356ecb?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
    Category(
        name:  "Hope",
        imagePath:
            'https://images.unsplash.com/photo-1581306382071-24fe449eed4c?q=80&w=1925&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
    Category(
        name:  "Growth",
        imagePath:
            'https://images.unsplash.com/photo-1496188757881-c6753f20c306?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjR8fGVtb3Rpb25hbHxlbnwwfHwwfHx8MA%3D%3D'),
    Category(
        name:  "Grief",
        imagePath:
            'https://images.unsplash.com/photo-1631911635433-c66b969831e5?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
    Category(
        name:  "Forgiveness",
        imagePath:
            'https://images.unsplash.com/photo-1719674572519-234f4051e48c?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
    Category(
        name: 'Joy',
        imagePath:
            'https://images.unsplash.com/photo-1628313388777-9b9a751dfc6a?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
    Category(
        name:   "Loneliness",
        imagePath:
            'https://images.unsplash.com/photo-1676881431510-4c1021d9c96f?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
    Category(
        name:   "Growth",
        imagePath:
            'https://images.unsplash.com/photo-1576874810759-375860e131b8?q=80&w=2069&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
    Category(
        name:  "Self-Discovery",
        imagePath:
            'https://images.unsplash.com/photo-1623239560402-bfd1b70a0185?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Explore By Topics",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
         
        ),
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // number of items in each row
            mainAxisSpacing: 19.0, // spacing between rows
            crossAxisSpacing: 12.0, // spacing between columns
          ),
          padding: EdgeInsets.all(8.0), // padding around the grid
          itemCount: categories.length, // total number of items
          itemBuilder: (context, index) {
            return GestureDetector(
                 onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPostsScreen(
                      category: categories[index].name,
                      headImage: categories[index].imagePath!,
                    ),
                  ),
                );
              },

              child: BlocProvider(
                create: (context) =>
                    GetPostBloc(postRepository: FirebasePostRepository())
                      ..add(GetPostsByCategory(
                          category: categories[index].name, pageKey: 1)),
                child: BlocBuilder<GetPostBloc, GetPostState>(
                  builder: (context, state) {
                    if(state.status == GetPostStatus.failure){
                      return Center(child: Text('Failed to fetch posts'));
                    }
              
                    if(state.status == GetPostStatus.success){
                        return ContainerImage(
                      categ: categories[index].name,
                      image: categories[index].imagePath!,
                      postNo: state.posts!.length,
                    );
              
                    }else{
                      return Container();
                    }
                  
                  },
                ),
              ),
            );
          },
        ));
  }
}
