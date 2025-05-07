import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';
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

    String voiceRachel = 'aEO01A4wXwd1O8GPgGlF'; // Replace if needed

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
                style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
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
                    IconButton(
                      onPressed: () async {
                        // Handle share icon tap

                        final image =
                            await screenshotController.captureFromWidget(
                                imageWidget(size: size, widget: widget));

                        saveAndShare(
                            image, widget.post.body!, widget.post.title);
                      },
                      icon: const Icon(Icons.share),
                      iconSize: 30,
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
                              // Handle favorite icon tap
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
                                : Icons.bookmark_border),
                            iconSize: 30,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: widget.post.id,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: widget
                                                      .post.myUser.image ==
                                                  null ||
                                              widget.post.myUser.image!.isEmpty
                                          ? const NetworkImage(
                                              'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png')
                                          : NetworkImage(
                                              widget.post.myUser.image!),
                                      backgroundColor: AppColors.primaryColor,
                                    ),
                                    title: Text(
                                      widget.post.myUser.name,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      formatTimeAgo(widget.post.createdAt),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white70),
                                    ),
                                  ),
                                ),
                                // Text(
                                //   widget.post.title,
                                //   style: TextStyle(
                                //     fontSize: 24,
                                //     fontWeight: FontWeight.bold,
                                //     color: Colors.white,
                                //   ),
                                // ),
                                if (_isLoadingVoice)
                                  const Center(
                                      child: CircularProgressIndicator()),
                                if (!_isLoadingVoice)
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 2),
                                    ),
                                    onPressed: () => playTextToSpeech(
                                        widget.post.body ?? ''),
                                    icon: const Icon(
                                      Icons.headphones,
                                      color: Colors.white70,
                                    ),
                                    label: const Text(
                                      "Listen",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Text(widget.post.genre!,
                          //     style: TextStyle(
                          //         fontSize: 16,
                          //         fontWeight: FontWeight.w600,
                          //         color: Colors.white70)),
                          // Text(
                          //   formatTimeAgo(widget.post.createdAt),
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.w700,
                          //       color: Colors.white70),
                          // ),
                          // SizedBox(height: 16),
                          // // Author Info Section
                          // ListTile(
                          //   contentPadding: EdgeInsets.zero,
                          //   leading: CircleAvatar(
                          //     radius: 30,
                          //     backgroundImage: widget.post.myUser.image ==
                          //                 null ||
                          //             widget.post.myUser.image!.isEmpty
                          //         ? NetworkImage(
                          //             'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png')
                          //         : NetworkImage(widget.post.myUser.image!),
                          //     backgroundColor: AppColors.primaryColor,
                          //   ),
                          //   title: Text(
                          //     widget.post.myUser.name,
                          //     style: GoogleFonts.lora(
                          //       fontSize: 20,
                          //       fontWeight: FontWeight.bold,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          //   subtitle: Text(
                          //     widget.post.myUser.handle != null
                          //         ? '@${widget.post.myUser.handle!}'
                          //         : '',
                          //     style: TextStyle(
                          //         color: Colors.white70, fontSize: 14),
                          //   ),
                          // ),
                          const SizedBox(height: 16),

                          widget.post.body == ''
                              ? Container(
                                  constraints:
                                      const BoxConstraints(minHeight: 100),
                                )
                              : Container(
                                  width: double.infinity,
                                  constraints: const BoxConstraints(
                                      minHeight: 100, minWidth: 90),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color.fromRGBO(0, 0, 0,
                                            0.5), // Top-left: semi-transparent black
                                        Color.fromRGBO(0, 0, 0,
                                            0.6), // Mid: slight darkness
                                        Color.fromRGBO(0, 0, 0,
                                            0.6), // Bottom-right: lighter transparent black
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    widget.post.body ?? '',
                                    style: TextStyle(
                                        wordSpacing: 8,
                                        fontFamily:
                                            GoogleFonts.manrope().fontFamily,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        height: 1.6),
                                  ),
                                ),
                          ElevatedButton.icon(
                            label: Text("Download Audio",
                                style: TextStyle(color: Colors.white)),
                            icon: Icon(Icons.download, color: Colors.white,),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 2),
                            ),
                            onPressed: () async {
                              // await requestStoragePermission();
                              //  var status = await Permission.storage.status;
                              //  print(status);
                              //    print(cachedAudios[widget.post.body]);
                              // if (status.isGranted) {
                              if (cachedAudios.containsKey(widget.post.body)) {
                                print(cachedAudios[widget.post.body]);
                                downloadAudioFile(
                                    cachedAudios[widget.post.body]!,
                                    'poem_audio');
                              }
                            },
                            
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
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
