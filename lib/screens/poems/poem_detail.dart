import 'dart:convert';
import 'dart:io';
 
import 'dart:typed_data';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/main.dart';
import 'package:olly_chat/screens/discover/components/head_image.dart';
import 'package:olly_chat/screens/poems/snippies/screenshotsnip.dart';
import 'package:olly_chat/screens/poems/widgets/article_cover.dart';
import 'package:olly_chat/screens/poems/widgets/custom_audio.dart';
import 'package:olly_chat/screens/poems/widgets/font_selection.dart';
import 'package:olly_chat/screens/poems/widgets/image_widget.dart';
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
  final PageController _pageController = PageController();

  String selectedFont = 'Schoolbell'; // Default font
  List<String> pages = [];

    void splitPoemIntoPages() {
    final mediaQuery = MediaQuery.of(context);
    final textStyle = TextStyle(
      fontSize: 18,
      height: 1.5,
      fontFamily: GoogleFonts.getFont(selectedFont).fontFamily,
    );

    final maxHeight = mediaQuery.size.height - 150; // Leave room for Listen button
    final words = widget.post.body!.split(' ');
    final buffer = StringBuffer();
    final painter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );

    pages.clear();
    for (final word in words) {
      final testText = '${buffer.toString()} $word';
      painter.text = TextSpan(text: testText.trim(), style: textStyle);
      painter.layout(maxWidth: mediaQuery.size.width - 40);

      if (painter.size.height > maxHeight) {
        pages.add(buffer.toString().trim());
        buffer.clear();
      }

      buffer.write('$word ');
    }

    if (buffer.isNotEmpty) {
      pages.add(buffer.toString().trim());
    }

    setState(() {});
  }


  // Function to show the bottom sheet for font selection
  void openFontSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FontSelectionBottomSheet(
          onFontSelected: (font) {
            setState(() {
              selectedFont = font; // Update font when selected
            });
            Navigator.pop(context); // Close the bottom sheet
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Switched to "$font" font'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }

  bool isBookmarked = false;
  final player = AudioPlayer(); //audio player obj that will play audio
  bool _isLoadingVoice = false; //for the progress indicator

  Map<String, File> cachedAudios = {}; // Cache to store audio files

  String formatTimeAgo(DateTime timestamp) {
    Duration difference = DateTime.now().difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} day ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hour ago';
    } else {
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

    final result = '';

    return result;
  }

  Future<String> saveAndShare(
      Uint8List bytes, String text, String subject) async {
    final dir = await getApplicationDocumentsDirectory();
    final image = await File('${dir.path}/flutter.png').create();
    image.writeAsBytesSync(bytes);

    // ignore: deprecated_member_use
    // var retrr =
    //     await Share.shareFiles([image.path], text: text, subject: subject);

    // return retrr as String;

    // Ensure a return statement or throw an exception
    return 'Image saved and shared successfully';
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    // Check if the post is bookmarked
    final userBlocState = BlocProvider.of<MyUserBloc>(context).state;
    if (userBlocState.status == MyUserStatus.success) {
      isBookmarked =
          userBlocState.user!.bookmarkedPosts!.contains(widget.post.id);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    // player.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _showScrollButton = true;
        _scrollIcon = Icons.arrow_upward;
      });
    } else if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
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
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (_scrollIcon == Icons.arrow_downward) {
      // Scroll to the bottom
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  
Future<void> shareRemoteImage(String imageUrl) async {
  try {
    // 1. Download the image
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to download image');
    }

    // 2. Save to a temporary file
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/shared_image.jpg');
    await file.writeAsBytes(response.bodyBytes);

    // 3. Share using share_plus
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Shared from VoiceHub ✨',
    );
  } catch (e) {
    print('Error sharing image: $e');
  }
}

  //For the Text To Speech
  Future<void> playTextToSpeech(String text) async {
    // var connectivityResult = await Connectivity().checkConnectivity();
    // if (connectivityResult == ConnectivityResult.none) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('No internet connection')),
    //   );
    //   return;
    // }

    // Use a unique file name based on the text
    final appDocDir = await getApplicationDocumentsDirectory();
    final audioFile = File('${appDocDir.path}/audio_${text.hashCode}.mp3');

    // If file exists, just play it
    if (await audioFile.exists()) {
      await playAudioFromBytes(audioFile);
      return;
    }

    setState(() {
      _isLoadingVoice = true;
    });

    String voiceRachel = '6OzrBCQf8cjERkYgzSg8'; // Replace if needed

    String url = 'https://api.elevenlabs.io/v1/text-to-speech/$voiceRachel';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'accept': 'audio/mpeg',
        'xi-api-key': eleApiKey,
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "text": text,
        "model_id": "eleven_monolingual_v1",
        "voice_settings": {
          "stability": .15,
          "similarity_boost": .75,
          "use_speaker_boost": true,
        }
      }),
    );

    setState(() {
      _isLoadingVoice = false;
    });

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;

      // Save to permanent storage
      await audioFile.writeAsBytes(bytes);

      // Cache in memory for quick reuse during this session
      cachedAudios[text] = audioFile;

      await playAudioFromBytes(audioFile);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio downloaded and saved')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to download audio')),
      );
    }
  }

  List<String> splitTextIntoPages(String text, {int maxCharsPerPage = 600}) {
   List<String> words = text.split(' ');
  List<String> pages = [];
  String currentPage = '';

  for (final word in words) {
    if ((currentPage + word).length > maxCharsPerPage) {
      pages.add(currentPage.trim());
      currentPage = '';
    }
    currentPage += '$word ';
  }

  if (currentPage.trim().isNotEmpty) {
    pages.add(currentPage.trim());
  }

  return pages;
  }

  Future<void> playAudioFromBytes(File audioFile) async {
    final audioSource = MyCustomSource(await audioFile.readAsBytes());
    await player.setAudioSource(audioSource);
    player.play();
    _showAudioPlayer(); // Show the audio player bottom sheet
  }

  // Method to format the duration
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.manageExternalStorage.request();
    }

    if (status.isGranted) {
      return true;
    } else {
      // Optional: direct user to app settings
      openAppSettings();
      return false;
    }
  }

  Future<void> downloadAudioFile(File cachedAudioFile, String filename) async {
    // final hasPermission = await requestStoragePermission();
    // if (!hasPermission) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Storage permission denied")),
    //   );
    //   return;
    // }

    final downloadsDirectory = await getExternalStorageDirectory();
    final newFilePath = '${downloadsDirectory!.path}/$filename.mp3';

    await cachedAudioFile.copy(newFilePath);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Audio saved to Downloads as $filename.mp3")),
    );
  }

  // Method to show the audio player in a bottom sheet
  void _showAudioPlayer() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StreamBuilder<Duration?>(
          stream: player.durationStream,
          builder: (context, snapshot) {
            final duration = snapshot.data ?? Duration.zero;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<Duration>(
                  stream: player.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final clampedPosition = position <= duration
                        ? position
                        : duration; // Clamp the position to the duration
                    return Column(
                      children: [
                        Slider(
                          min: 0.0,
                          max: duration.inMilliseconds.toDouble(),
                          value: clampedPosition.inMilliseconds.toDouble(),
                          onChanged: (value) {
                            player.seek(Duration(milliseconds: value.toInt()));
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatDuration(clampedPosition)),
                              Text(_formatDuration(duration - clampedPosition)),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.replay_10),
                      onPressed: () {
                        player.seek(
                            player.position - const Duration(seconds: 10));
                      },
                    ),
                    StreamBuilder<PlayerState>(
                      stream: player.playerStateStream,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;
                        final processingState = playerState?.processingState;
                        final playing = playerState?.playing;
                        if (!(playing ?? false)) {
                          return IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: player.play,
                          );
                        } else if (processingState !=
                            ProcessingState.completed) {
                          return IconButton(
                            icon: const Icon(Icons.pause),
                            onPressed: player.pause,
                          );
                        } else {
                          return IconButton(
                            icon: const Icon(Icons.replay),
                            onPressed: () => player.seek(Duration.zero),
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.forward_10),
                      onPressed: () {
                        player.seek(
                            player.position + const Duration(seconds: 10));
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deltaJson = widget.post.body;
    String extractedText = '';

    try {
      final deltaOps = jsonDecode(deltaJson!);
      for (var op in deltaOps) {
        extractedText += op['insert'] ?? '';
      }
    } catch (e) {
      extractedText = 'Error loading post content';
    }

    String extractTextFromDelta(String? deltaJson) {
      if (deltaJson == null || deltaJson.isEmpty) {
        return '';
      }

      try {
        final decoded = jsonDecode(deltaJson);

        // If it's a list, assume it's a Quill Delta
        if (decoded is List) {
          String result = '';
          for (var op in decoded) {
            result += op['insert'] ?? '';
          }
          return result;
        }

        // If it's not a list, just return the original (maybe plain text)
        return deltaJson;
      } catch (e) {
        // Fallback: Treat as plain text if not JSON
        return deltaJson;
      }
    }

    final List<String> contentPages = splitTextIntoPages(
      extractTextFromDelta(widget.post.body),
      maxCharsPerPage: 600, // Tweak for UX
    );

    Size size = MediaQuery.of(context).size;
    return Screenshot(
      controller: screenshotController,
      child: BlocBuilder<MyUserBloc, MyUserState>(
        builder: (context, state) {
          if (state.status == MyUserStatus.success) {}
          return Scaffold(
            extendBodyBehindAppBar: true,

            appBar: AppBar(
              centerTitle: true,
              title: Text(
                widget.post.title,
                style: TextStyle(
                  fontFamily: GoogleFonts.getFont(selectedFont).fontFamily,
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconTheme: const IconThemeData(
                color: Colors.white,
                size: 30,
              ),
              backgroundColor: Colors.black.withOpacity(0.3),
              elevation: 0,
              actions: [
                Row(
                  children: [
                    // Font Icon with Tooltip
                    IconButton(
                      icon: Icon(Icons.text_fields, color: AppColors.secondaryColor,), // Font-related icon
                      onPressed:
                          openFontSelectionBottomSheet, // Open font selection
                      tooltip: 'Switch Font', // Tooltip to explain action
                    ),
                    BlocListener<MyUserBloc, MyUserState>(
                      listener: (context, state) {
                        // TODO: implement listener
                        if (state.status == MyUserStatus.success) {
                          setState(() {
                            isBookmarked = state.user!.bookmarkedPosts!
                                .contains(widget.post.id);
                          });
                        }
                      },
                      child: BlocBuilder<MyUserBloc, MyUserState>(
                        builder: (context, state) {
                          if (state.status == MyUserStatus.success) {
                            isBookmarked = state.user!.bookmarkedPosts!
                                .contains(widget.post.id);
                          }
                          return IconButton(
                            onPressed: () {
                              // Handle bookmark icon tap
                              if (isBookmarked) {
                                BlocProvider.of<MyUserBloc>(context).add(
                                    UnbookmarkPost(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        widget.post.id));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Poem removed from bookmark'),
                                  ),
                                );
                              } else {
                                BlocProvider.of<MyUserBloc>(context).add(
                                    BookmarkPost(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        widget.post.id));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Poem added to bookmark'),
                                  ),
                                );
                              }
                              setState(() {
                                isBookmarked = !isBookmarked;
                              });
                            },
                            icon: Icon(isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,  color: AppColors.secondaryColor,),
                            iconSize: 30,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
         floatingActionButton: FloatingActionButton(
          child:  Icon(Icons.share, color:Colors.white,),
          onPressed: () async{
          await  shareRemoteImage(widget.post.thumbnail!);
            // Share.share(
            //   'Check out this poem: ${widget.post.title} \n\n${widget.post.body}',
            //   subject: '*Poem from VoiceHub*',
            // );
      }),
            body: Stack(
              children: [
              
                // Background image
                // Background image without opacity or blend mode
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: widget.post.thumbnail!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),

                // Gradient overlay (on top of image)
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(
                              0, 0, 0, 0.7), // Top: fully transparent
                          Color.fromRGBO(0, 0, 0, 0.6), // Mid: slight darkness
                          Color.fromRGBO(0, 0, 0,
                              0.9), // Bottom: strong dark// Bottom: fade to transparent
                        ],
                      ),
                    ),
                  ),
                ),
                // Main content
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        
                        PageView.builder(
                          controller: _pageController,
                          itemCount: contentPages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (index == 0) ...[
                                    Hero(
                                      tag: widget.post.id,
                                      child: ListTile(
                                        trailing: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.deepPurple,
                                            shape: const StadiumBorder(),
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 2),
                                          ),
                                          onPressed: () => playTextToSpeech(
                                              widget.post.body ?? ''),
                                          icon: const Icon(Icons.headphones,
                                              color: Colors.white70),
                                          label:  Text("Listen",
                                              style: TextStyle(
                                                 fontFamily: GoogleFonts.getFont(selectedFont).fontFamily,
                                                  color: Colors.white)),
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                        leading: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: widget.post.myUser
                                                          .image ==
                                                      null ||
                                                  widget.post.myUser.image!
                                                      .isEmpty
                                              ? const NetworkImage(
                                                  'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png')
                                              : NetworkImage(
                                                  widget.post.myUser.image!),
                                        ),
                                        title: Text(widget.post.myUser.name,
                                            style: TextStyle(
                                               fontFamily: GoogleFonts.getFont(selectedFont).fontFamily,
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        subtitle: Text(
                                          formatTimeAgo(
                                              widget.post.createdAt),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white70),
                                        ),
                                      ),
                                    ),
                                  
                                  ],
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFAF3E0),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Text(
                                          contentPages[index],
                                          style: TextStyle(
                                            wordSpacing: 5,
                                            fontFamily: GoogleFonts.getFont(
                                                    selectedFont)
                                                .fontFamily,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            letterSpacing: 1,
                                            height: 1.6,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (index == 0 && contentPages.length > 1)
                                    const Center(
                                      child: Text(
                                        'Swipe to continue →',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.white70),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                        if (contentPages.length > 1)
                          Positioned(
                            bottom: 1,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: SmoothPageIndicator(
                                controller: _pageController,
                                count: contentPages.length,
                                effect: WormEffect(
                                  activeDotColor: Colors.white,
                                  dotColor: Colors.white30,
                                  dotHeight: 8,
                                  dotWidth: 8,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Floating scroll button
                if (_showScrollButton)
                  Positioned(
                    right: 16,
                    bottom: 120,
                    child: FloatingActionButton(
                      onPressed: _handleScrollButtonPressed,
                      backgroundColor: Colors.deepPurple,
                      child: Icon(_scrollIcon),
                    ),
                  ),
              ],
            ),
            // floatingActionButton: Visibility(
            //   visible: _showScrollButton,
            //   child: FloatingActionButton(
            //     onPressed: _handleScrollButtonPressed,
            //     child: Icon(_scrollIcon),
            //   ),
            // ),
          );
        },
      ),
    );
  }
}
