import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lottie/lottie.dart';
import 'package:olly_chat/theme/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:post_repository/post_repository.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class PoemDetailScreen extends StatefulWidget {
  final Post post;

  const PoemDetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  _PoemDetailScreenState createState() => _PoemDetailScreenState();
}

class _PoemDetailScreenState extends State<PoemDetailScreen> {
  ScreenshotController screenshotController = ScreenshotController();
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
  }

  else if(difference.inDays >= 1){
    return '${difference.inDays} day ago';

  }
   else if(difference.inHours >= 1){
    return '${difference.inHours} hour ago';

  }
   else {
    return 'just now';
  }
}


  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = 'screenshot_$time';

    final result = await ImageGallerySaver.saveImage(bytes, name: name);

    return result['filepath'];
  }

  Future<String> saveAndShare(Uint8List bytes, String text, String subject) async {
    final dir = await getApplicationDocumentsDirectory();
    final image = await File('${dir.path}/flutter.png').create();
     image.writeAsBytesSync(bytes);

    // ignore: deprecated_member_use
    var retrr = await Share.shareFiles([image.path],text:text, subject: subject );

    return retrr as String;
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
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Genre" , style: TextStyle(fontWeight: FontWeight.bold),),
          iconTheme: IconThemeData(
            size: 30,
          ),
          backgroundColor: Colors.transparent,
          actions: [
            Row(
              children: [
                IconButton(
                  onPressed: ()  async {
      
                    // Handle share icon tap

                     final image =
                      await screenshotController.captureFromWidget(imageWidget(size: size, widget: widget));

      
                     saveAndShare(image, widget.post.body!, widget.post.title);
      
      
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
                    imageWidget(size: size, widget: widget),
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
                  backgroundImage: NetworkImage(widget.post.myUser.image == '' ? 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png':widget.post.myUser.image!),
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
      ),
    );
  }}

class imageWidget extends StatelessWidget {
  const imageWidget({
    super.key,
    required this.size,
    required this.widget,
  });

  final Size size;
  final PoemDetailScreen widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.5 - 5,
      child: CachedNetworkImage(
        imageUrl: widget.post.thumbnail!,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            Center(child: Lottie.asset('assets/lotti/imageload.json')),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}