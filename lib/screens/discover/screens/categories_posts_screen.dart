import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:post_repository/post_repository.dart';
 

class CategoryPostsScreen extends StatelessWidget {
  final String category;

  const CategoryPostsScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetPostBloc(postRepository: FirebasePostRepository())..add(GetPostsByCategory(category: category, pageKey: 1)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(category),
        ),
        body: BlocBuilder<GetPostBloc, GetPostState>(
          builder: (context, state) {
            if (state.status == GetPostStatus.failure) {
              return Center(child: Text('Failed to fetch posts'));
            }
            if (state.status == GetPostStatus.success) {
              if (state.posts!.isEmpty) {
                return Center(child: Text('No posts for this category'));
              }
              return ListView.builder(
                itemCount: state.posts!.length,
                itemBuilder: (context, index) {
                  final post = state.posts![index];
                  return ListTile(
                    title: Text(post.title),
                    subtitle: Text(post.myUser.name),
                  
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
