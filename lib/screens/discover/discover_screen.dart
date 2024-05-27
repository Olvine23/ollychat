import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/components/article_list_card.dart';
import 'package:olly_chat/components/row_tile.dart';
import 'package:olly_chat/screens/bookmarks/bookmark.dart';
import 'package:olly_chat/screens/discover/components/container_image.dart';
import 'package:olly_chat/screens/discover/components/writers_container.dart';
import 'package:olly_chat/screens/discover/widgets/post_list.dart';
import 'package:olly_chat/screens/discover/widgets/section_title.dart';
import 'package:olly_chat/screens/home/widgets/article_card.dart';
import 'package:olly_chat/screens/home/widgets/shimmer_widget.dart';
import 'package:olly_chat/screens/poems/poem_detail.dart';
import 'package:olly_chat/theme/colors.dart';
import 'package:shimmer/shimmer.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<GetPostBloc>().add(const LoadMorePosts(pageKey: 3));
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // debugInvertOversizedImages = true;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Discover",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const BookMarkScreen();
              }));
            },
            icon: Icon(
              Icons.bookmark_added_outlined,
              size: 30.dp,
              color: AppColors.secondaryColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20.dp),
              child: const TextField(
                decoration: InputDecoration(
                  labelText: 'Search for article or writer',
                  border: OutlineInputBorder(
                    
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
           SectionTitle(title: 'Explore by topics', scrollController: _scrollController,),
          
            const TopicList(),
             SizedBox(height: 2.h),
            const SectionTitle(title: 'Most Popular'),
            
            const PostList(),
            SizedBox(height: 2.h),
            const SectionTitle(title: 'Top Writers'),
             SizedBox(height: 1.h),
            WriterList(),
            const SectionTitle(title: 'Our Recommendations'),
            // Your code for recommendations here
            
            const NewArticlesList(),
          ],
        ),
      ),
    );
  }
}




class TopicList extends StatelessWidget {
  const TopicList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2 - 240,
      child: ListView.builder(
        cacheExtent: 1000,
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ContainerImage(),
          );
        },
      ),
    );
  }
}

class WriterList extends StatelessWidget {
  const WriterList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2 - 260,
      child: ListView.builder(
        cacheExtent: 1000,
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        itemBuilder: (context, index) {
          return const WritersContainer();
        },
      ),
    );
  }
}

class NewArticlesList extends StatelessWidget {
  const NewArticlesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetPostBloc, GetPostState>(
      builder: (context, state) {
        if (state.status == GetPostStatus.success) {
          return ListView.builder(
            shrinkWrap: true,
            cacheExtent: 1000,
            physics: const NeverScrollableScrollPhysics(),
            // itemCount: state.posts?.length ?? 0,
            itemCount: 10,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Handle onTap
                },
                child: RowTile(
                  imageUrl: state.posts![index].thumbnail!,
                  title: state.posts![index].title,
                  userAvatar: state.posts![index].myUser.image!,
                  authorName: state.posts![index].myUser.name,
                ),
              );
            },
          );
        } else if (state.status == GetPostStatus.unknown) {
          return Shimmer.fromColors(
            highlightColor: Colors.white54,
            baseColor: const Color(0xffdedad7),
            child: project_screen_shimmer(context),
          );
        }
        return const Text("No data available"); // Handle other states
      },
    );
  }
}
