import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
 

class PostSearchScreen extends StatelessWidget {
  const PostSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Posts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search for posts...',
              ),
              onChanged: (query) {
                context.read<GetPostBloc>().add(SearchPosts(query));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<GetPostBloc, GetPostState>(
              builder: (context, state) {
                if (state.status == GetPostStatus.success) {
                  if (state.posts!.isEmpty) {
                    return const Center(child: Text('No posts found.'));
                  } else {
                    return ListView.builder(
                      itemCount: state.posts!.length,
                      itemBuilder: (context, index) {
                        final post = state.posts![index];
                        return ListTile(
                          title: Text(post.title),
                           
                        );
                      },
                    );
                  }
                } else if(state.status == GetPostStatus.unknown) {
                  return const Center(child: Text('Loading ....'));
                } else return Text("Whoaaa");
              },
            ),
          ),
        ],
      ),
    );
  }
}