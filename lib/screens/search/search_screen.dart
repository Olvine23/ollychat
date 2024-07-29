import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/screens/poems/poem_detail.dart';
import 'package:user_repository/user_repository.dart';

class PostSearchScreen extends StatefulWidget {
  const PostSearchScreen({super.key});

  @override
  State<PostSearchScreen> createState() => _PostSearchScreenState();
}

class _PostSearchScreenState extends State<PostSearchScreen> {
   final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<GetPostBloc>().add(ClearSearch());
  }

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
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for posts...',
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : null,
              ),
              onChanged: (query) {
                context.read<GetPostBloc>().add(SearchPosts(query));
                setState(() {}); // To update the suffix icon
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<GetPostBloc, GetPostState>(
              builder: (context, state) {
                if (state.status == GetPostStatus.success) {
                  final posts = state.searchResults ?? state.posts;
                  if (posts == null || posts.isEmpty) {
                    return const Center(child: Text('No posts found.'));
                  } else {
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                         return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return BlocProvider(
                                create: (context) => MyUserBloc(myUserRepository: FirebaseUserRepo()),
                                child: PoemDetailScreen(post: post),
                              );
                            }));
                          },
                          child: ListTile(
                            title: Text(post.title),
                          ),
                        );
                      },
                    );
                  }
                } else if (state.status == GetPostStatus.unknown) {
                  return const Center(child: Text('Loading ....'));
                } else if (state.status == GetPostStatus.failure) {
                  return const Center(child: Text('Failed to load posts.'));
                } else {
                  return const Center(child: Text('Unknown state.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
