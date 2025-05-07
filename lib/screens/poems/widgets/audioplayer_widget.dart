
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWidget extends StatelessWidget {
  final AudioPlayer player;

  const AudioPlayerWidget({super.key, required this.player});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.grey.shade900,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<Duration?>(
            stream: player.durationStream,
            builder: (context, snapshot) {
              final duration = snapshot.data ?? Duration.zero;
              return StreamBuilder<Duration>(
                stream: player.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final clampedPosition = position <= duration ? position : duration;

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(clampedPosition), style: TextStyle(color: Colors.white)),
                          Text(_formatDuration(duration - clampedPosition), style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.replay_10, color: Colors.white),
                onPressed: () => player.seek(player.position - Duration(seconds: 10)),
              ),
              StreamBuilder<PlayerState>(
                stream: player.playerStateStream,
                builder: (context, snapshot) {
                  final playing = snapshot.data?.playing ?? false;
                  final processing = snapshot.data?.processingState;

                  if (!playing) {
                    return IconButton(
                      icon: Icon(Icons.play_arrow, color: Colors.white),
                      onPressed: player.play,
                    );
                  } else if (processing != ProcessingState.completed) {
                    return IconButton(
                      icon: Icon(Icons.pause, color: Colors.white),
                      onPressed: player.pause,
                    );
                  } else {
                    return IconButton(
                      icon: Icon(Icons.replay, color: Colors.white),
                      onPressed: () => player.seek(Duration.zero),
                    );
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.forward_10, color: Colors.white),
                onPressed: () => player.seek(player.position + Duration(seconds: 10)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
