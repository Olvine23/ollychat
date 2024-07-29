import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/screens/bookmarks/bookmark.dart';
import 'package:olly_chat/screens/discover/widgets/new_articles.dart';
import 'package:olly_chat/screens/discover/widgets/post_list.dart';
import 'package:olly_chat/screens/discover/widgets/section_title.dart';
import 'package:olly_chat/screens/discover/widgets/topic_list.dart';
import 'package:olly_chat/theme/colors.dart';
import 'package:post_repository/post_repository.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<GetPostBloc>().add(const LoadMorePosts(pageKey: 3));
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<GetPostBloc>().add(ClearSearch());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Discover",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BookMarkScreen();
                }));
              },
              icon: Icon(
                Icons.bookmark,
                size: 30.dp,
                color: AppColors.secondaryColor,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20.dp),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (query) {
                      context.read<GetPostBloc>().add(SearchPosts(query));
                      setState(() {}); // Update suffix icon visibility
                    },
                    decoration: InputDecoration(
                      labelText: 'Search for article...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18)),
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: _clearSearch,
                            )
                          : null,
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    BlocBuilder<GetPostBloc, GetPostState>(
                      builder: (context, state) {
                        if (state.status == GetPostStatus.success) {
                          final posts = state.searchResults ?? state.posts ?? [];
                          if (posts.isEmpty) {
                            return Container();
                          }
                          return Container(
                            constraints: BoxConstraints(maxHeight: 200),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                final post = posts[index];
                                return ListTile(
                                  title: Text(post.title),
                                  onTap: () {
                                    
                                  },
                                );
                              },
                            ),
                          );
                        } else if (state.status == GetPostStatus.failure) {
                          return const Center(
                              child: Text('Failed to load posts.'));
                        } else {
                          return Container();
                        }
                      },
                    ),
                ],
              ),
            ),
            SectionTitle(
              title: 'Explore by topics',
              scrollController: _scrollController,
            ),
            SizedBox(height: 2.h),
            TopicList(),
            SizedBox(height: 4.h),
            const SectionTitle(title: 'Most Popular'),
            SizedBox(height: 2.h),
            const PostList(),
            SizedBox(height: 2.h),
            const SectionTitle(title: 'Recommendations'),
            SizedBox(height: 2.h),
            const NewArticlesList(),
          ],
        ),
      ),
    );
  }
}
