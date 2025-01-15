import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:blue_music_player/services/song_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayerSongProgress extends StatelessWidget {
  final Duration totalDuration;
  final SongHandler songHandler;

  const PlayerSongProgress({
    super.key,
    required this.totalDuration,
    required this.songHandler,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: AudioService.position,
      builder: (context, positionSnapshot) {
        // Retrieve the current position from the stream
        Duration? position = positionSnapshot.data;

        // Display the ProgressBar widget
        return ProgressBar(
          // Set the progress to the current position or zero if null
          progress: position ?? Duration.zero,
          // Set the total duration of the song
          total: totalDuration,
          // Callback for seeking when the user interacts with the progress bar
          onSeek: (position) {
            songHandler.seek(position);
          },
          // Customize the appearance of the progress bar
          barHeight: 4,
          thumbRadius: 8,
          thumbGlowRadius: 12,
          timeLabelLocation: TimeLabelLocation.below,
          timeLabelPadding: 4,
          thumbColor: Color(0xffB7B7B7),
          timeLabelTextStyle: TextStyle(
            color: Color(0xff878787),
          ),
          progressBarColor: Color(0xffB7B7B7),
          bufferedBarColor: Colors.transparent,
          baseBarColor: Color(0x30888888),
        );
      },
    );
  }
}
