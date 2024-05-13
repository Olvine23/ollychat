import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:olly_chat/theme/colors.dart';
import 'package:post_repository/post_repository.dart';

class PoemDetailScreen extends StatefulWidget {
  final Post post;

  const PoemDetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  _PoemDetailScreenState createState() => _PoemDetailScreenState();
}

class _PoemDetailScreenState extends State<PoemDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollButton = false;
  IconData _scrollIcon = Icons.arrow_upward;

  String formatTimeAgo(DateTime timestamp) {
  Duration difference = DateTime.now().difference(timestamp);

  if (difference.inDays > 0) {
    return '${difference.inDays} days ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hours ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minutes ago';
  } else {
    return 'just now';
  }
}


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _showScrollButton = true;
        _scrollIcon = Icons.arrow_upward;
      });
    } else if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _showScrollButton = true;
        _scrollIcon = Icons.arrow_downward;
      });
    } else {
      setState(() {
        _showScrollButton = false;
      });
    }
  }

  void _handleScrollButtonPressed() {
    if (_scrollIcon == Icons.arrow_upward) {
      // Scroll to the top
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (_scrollIcon == Icons.arrow_downward) {
      // Scroll to the bottom
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Genre"),
        iconTheme: IconThemeData(
          size: 30,
        ),
        backgroundColor: Colors.transparent,
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // Handle share icon tap
                },
                color: AppColors.secondaryColor,
                icon: Icon(Icons.share),
                iconSize: 30,
              ),
              IconButton(
                onPressed: () {
                  // Handle favorite icon tap
                },
                color: AppColors.secondaryColor,
                icon: Icon(Icons.favorite),
                iconSize: 30,
              ),
              IconButton(
                 color: AppColors.secondaryColor,
                onPressed: () {
                  // Handle settings icon tap
                },
                icon: Icon(Icons.settings),
                iconSize: 30,
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    height: size.height * 0.5 - 5,
                    child: CachedNetworkImage(
                      imageUrl: widget.post.thumbnail!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Center(child: Lottie.asset('assets/lotti/imageload.json')),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.post.title,
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
                backgroundImage: NetworkImage(widget.post.myUser.image!),
                backgroundColor: AppColors.primaryColor,
              ),
              title: Text(
                widget.post.myUser.name,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w900),
              ),
              subtitle: const Text("@olly_poet"),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.primaryColor,
                ),
                onPressed: () {},
                child: const Text("Follow"),
              ),
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
                  Text(formatTimeAgo(widget.post.createdAt,), style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600, color: AppColors.secondaryColor),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MarkdownBody(
                styleSheet: MarkdownStyleSheet(
                  
                  h1: const TextStyle(fontSize: 24, color: Colors.blue),
                  p: GoogleFonts.ebGaramond(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.dp
                  ),
                  code: const TextStyle(fontSize: 14, color: Colors.green),
                ),
                shrinkWrap: true,
                data: widget.post.body!,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: _showScrollButton,
        child: FloatingActionButton(
          onPressed: _handleScrollButtonPressed,
          child: Icon(_scrollIcon),
        ),
      ),
    );
  }}