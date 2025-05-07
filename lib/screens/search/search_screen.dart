import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PoetryVideoList extends StatefulWidget {
  @override
  _PoetryVideoListState createState() => _PoetryVideoListState();
}

class _PoetryVideoListState extends State<PoetryVideoList> {
  final String apiKey = 'AIzaSyDBYnv-CN4sytn4KuiEv7yHdZ39wpObTSE';
  final String channelId = 'UC5DH3eN81b0RGJ7Xj3fsjVg';
  List videos = [];
  List playlistvideos = [];

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    final url =
        'https://www.googleapis.com/youtube/v3/search?key=$apiKey&channelId=$channelId&part=snippet,id&order=date&maxResults=50';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final items = data['items'];
      if (items != null) {
        setState(() {
          videos = items
              .where((item) =>
                  item['id'] != null &&
                  item['id']['kind'] == 'youtube#video' &&
                  item['id']['videoId'] != null)
              .toList();
        });
        print("Videos fetched successfully: ${videos.length} videos found.");
      } else {
        print("No videos found in the response.");
      }
    } else {
      print("Failed to fetch videos: ${response.statusCode}");
    }
  }

  void playVideo(
      String videoId, String title, String description, List relatedVideos) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          videoId: videoId,
          title: title,
          description: description,
          relatedVideos: relatedVideos,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                // Add search functionality later
              },
            ),
          ],
          leading: Image.asset('assets/images/nobg.png', height: 100),
          title: Text('Spoken Word Videos', style: TextStyle(fontWeight: FontWeight.bold),)),
      body: RefreshIndicator(
        onRefresh: fetchVideos,
        child: videos.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  final snippet = video['snippet'];
                  final title = snippet['title'];
                  final thumbnails = snippet['thumbnails'];
                  final thumbnail = thumbnails['maxres']?['url'] ??
                      thumbnails['standard']?['url'] ??
                      thumbnails['high']?['url'] ??
                      thumbnails['medium']?['url'] ??
                      thumbnails['default']?['url'] ??
                      '';
                  final description = snippet['description'];
                  final videoId = video['id']['videoId'];
                  final publishedAt = snippet['publishedAt'];

                  final publishedDate = DateTime.tryParse(publishedAt);
                  final timeAgo = publishedDate != null
                      ? timeago.format(publishedDate)
                      : 'Some time ago';

                  return GestureDetector(
                    onTap: () => playVideo(videoId, title, description, videos),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Thumbnail
                          Image.network(
                            thumbnail,
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundImage: NetworkImage(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQivN5daDMswnTGikkuLVUaCgPP9uqTcqtBNw&s'), // static icon
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Button Poetry • $timeAgo ',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;
  final String title;
  final String description;
  final List relatedVideos;

  const VideoPlayerScreen({
    required this.videoId,
    required this.title,
    required this.description,
    required this.relatedVideos,
  });

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        isLive: false,
        enableCaption: true,
        forceHD: true,
        hideThumbnail: true,
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light); // or dark
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  void _playAnotherVideo(String videoId, String title, String description) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          videoId: videoId,
          title: title,
          description: description,
          relatedVideos: widget.relatedVideos,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        showVideoProgressIndicator: true,
        controller: _controller),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Colors.black,
       body: SafeArea(
  child: CustomScrollView(
    slivers: [
      // Player (Fixed at the top)
      SliverToBoxAdapter(
        child: player,
      ),

      // Title & Description
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: TextStyle(color: Colors.white70, fontSize: 14),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ),

      const SliverToBoxAdapter(
        child: Divider(color: Colors.white24),
      ),

      // Related Videos
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Related Videos',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),

      // Related Videos List
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final video = widget.relatedVideos[index];
            final videoId = video['id']['videoId'];
            final title = video['snippet']['title'];
            final thumbnail = video['snippet']['thumbnails']['high']['url'];
            final description = video['snippet']['description'];

            return GestureDetector(
              onTap: () => _playAnotherVideo(videoId, title, description),
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: Colors.grey[900],
                child: Row(
                  children: [
                    Image.network(thumbnail,
                        width: 120, height: 70, fit: BoxFit.cover),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          childCount: widget.relatedVideos.length,
        ),
      ),
    ],
  ),
)

        );
      },
    );
  }
}
