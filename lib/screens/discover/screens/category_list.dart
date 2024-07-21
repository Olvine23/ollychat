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
        name: 'Love',
        imagePath:
            'https://images.unsplash.com/photo-1544911845-1f34a3eb46b1?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzR8fGxvdmV8ZW58MHx8MHx8fDA%3D'),
    Category(
        name: 'Art',
        imagePath:
            'https://images.unsplash.com/photo-1547891654-e66ed7ebb968?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8YXJ0fGVufDB8fDB8fHww'),
    Category(
        name: 'Health',
        imagePath:
            'https://images.unsplash.com/photo-1549890762-0a3f8933bc76?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjJ8fGhlYWx0aHxlbnwwfHwwfHx8MA%3D%3D'),
    Category(
        name: 'Emotional',
        imagePath:
            'https://images.unsplash.com/photo-1496188757881-c6753f20c306?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjR8fGVtb3Rpb25hbHxlbnwwfHwwfHx8MA%3D%3D'),
    Category(
        name: 'Entertainment',
        imagePath:
            'https://images.unsplash.com/photo-1415886541506-6efc5e4b1786?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
    Category(
        name: 'Sports',
        imagePath:
            'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fHNwb3J0c3xlbnwwfHwwfHx8MA%3D%3D'),
    Category(
        name: 'Education',
        imagePath:
            'https://images.unsplash.com/photo-1580582932707-520aed937b7b?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fGVkdWNhdGlvbnxlbnwwfHwwfHx8MA%3D%3D'),
    Category(
        name: 'Travel',
        imagePath:
            'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjJ8fHRyYXZlbHxlbnwwfHwwfHx8MA%3D%3D'),
    Category(
        name: 'Food',
        imagePath:
            'https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzF8fGZvb2R8ZW58MHx8MHx8fDA%3D'),
    Category(
        name: 'Lifestyle',
        imagePath:
            'https://images.unsplash.com/photo-1501504905252-473c47e087f8?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
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
