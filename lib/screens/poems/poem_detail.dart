import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
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

    final result = await ImageGallerySaver.saveImage(bytes, name: name);

    return result['filepath'];
  }

  Future<String> saveAndShare(
      Uint8List bytes, String text, String subject) async {
    final dir = await getApplicationDocumentsDirectory();
    final image = await File('${dir.path}/flutter.png').create();
    image.writeAsBytesSync(bytes);

    // ignore: deprecated_member_use
    var retrr =
        await Share.shareFiles([image.path], text: text, subject: subject);

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
    player.dispose();
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

  //For the Text To Speech
  Future<void> playTextToSpeech(String text) async {
    // Check network connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // Device is offline, handle accordingly (e.g., show a message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No internet connection'),
        ),
      );
      return;
    }
     // Check if audio is already cached
    if (cachedAudios.containsKey(text)) {
      await playAudioFromBytes(cachedAudios[text]!);
      return;
    }
    //display the loading icon while we wait for request
    setState(() {
      _isLoadingVoice = true; //progress indicator turn on now
    });

    String voiceRachel =
        'aEO01A4wXwd1O8GPgGlF'; //Rachel voice - change if you know another Voice ID

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
      _isLoadingVoice = false; //progress indicator turn off now
    });

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes; //get the bytes ElevenLabs sent back

      // Get the temporary directory on the device
      final cacheDir = await getTemporaryDirectory();

      // Save the audio bytes to a file in the cache directory
      File audioFile = File(
          '${cacheDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.mp3');
      await audioFile.writeAsBytes(bytes);

      // Cache the audio file
      cachedAudios[text] = audioFile;

      await playAudioFromBytes(audioFile);

      // Save the audio bytes to a file
      // File audioFile = File('$tempPath/audio.mp3');
      // await audioFile.writeAsBytes(bytes);

      // Print out the path where the file is saved
      print('Audio saved to: ${audioFile.path}');

      // Show a message indicating that the audio has been downloaded
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Audio downloaded successfully'),
        ),
      );
      // await player.setAudioSource(MyCustomSource(
      //     bytes)); //send the bytes to be read from the JustAudio library
      // player.play(); //play the audio
    } else {
      // throw Exception('Failed to load audio');
      return;
    }
  } //getResponse from Eleven Labs

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
                      icon: Icon(Icons.replay_10),
                      onPressed: () {
                        player.seek(player.position - Duration(seconds: 10));
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
                            icon: Icon(Icons.play_arrow),
                            onPressed: player.play,
                          );
                        } else if (processingState !=
                            ProcessingState.completed) {
                          return IconButton(
                            icon: Icon(Icons.pause),
                            onPressed: player.pause,
                          );
                        } else {
                          return IconButton(
                            icon: Icon(Icons.replay),
                            onPressed: () => player.seek(Duration.zero),
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.forward_10),
                      onPressed: () {
                        player.seek(player.position + Duration(seconds: 10));
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
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
        
          
          title: Text(
            widget.post.genre == null ? 'Genre' : widget.post.genre!,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: Colors.transparent,
          actions: [
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    // Handle share icon tap

                    final image = await screenshotController.captureFromWidget(
                        imageWidget(size: size, widget: widget));

                    saveAndShare(image, widget.post.body!, widget.post.title);
                  },
                   
                  icon: Icon(Icons.share),
                  iconSize: 30,
                ),
                IconButton(
                  onPressed: () {
                    // Handle favorite icon tap
                    context.read<MyUserBloc>().add(BookmarkPost(FirebaseAuth.instance.currentUser!.uid, widget.post.id));


                  },
                  
                  icon: Icon(Icons.favorite),
                  iconSize: 30,
                ),
                
              ],
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 300), 
                  // imageWidget(size: size, widget: widget),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.post.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Listen",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () async{
            
                                _showAudioPlayer();
            
                               await  playTextToSpeech(widget.post.body!);
                              },
                              child: _isLoadingVoice
                                  ? Text("loading ...", style: Theme.of(context).textTheme.bodySmall,)
                                  : Icon(
                                      Icons.play_circle,
                                      color: AppColors.secondaryColor,
                                    ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(widget.post.myUser.image == ''
                          ? 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png'
                          : widget.post.myUser.image!),
                      backgroundColor: AppColors.primaryColor,
                    ),
                    title: Text(
                      widget.post.myUser.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w900),
                    ),
                    subtitle:  Text(widget.post.myUser.handle == null ? "handle": widget.post.myUser.handle!),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.primaryColor,
                      ),
                      onPressed: () {
                        
                      },
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 12),
                            child: Text(
                              widget.post.genre == null
                                  ? 'Genre'
                                  : widget.post.genre!,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          formatTimeAgo(
                            widget.post.createdAt,
                          ),
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondaryColor),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.center,
                      // child: Text(widget.post.body!),
                      child: MarkdownBody(
                        styleSheet: MarkdownStyleSheet(
                          textAlign: WrapAlignment.center,
                          h1: const TextStyle(fontSize: 24, color: Colors.blue),
                          p: GoogleFonts.ebGaramond(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.dp,
                          ),
                          code: const TextStyle(fontSize: 14, color: Colors.green),
                        ),
                        shrinkWrap: true,
                        data: widget.post.body!,
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),

                Padding(
                    padding:  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Comments", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
                        Icon(Icons.arrow_forward_outlined, size: 30,color: AppColors.secondaryColor,)
                      ],
                    ),
                  ),


                  Align(
                    alignment: Alignment.center,
                    child: Text("Coming soon ...."))


                ],
              ),
            ),

              Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: ArticleCover(
                        categ: '',
                        image: widget.post.thumbnail!,
                        stateCount: null,
                        
                        
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
      ),
    );
  }
}
