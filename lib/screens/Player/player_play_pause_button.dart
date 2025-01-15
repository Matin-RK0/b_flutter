// PlayPauseButton class responsible for displaying a play/pause button
import 'package:audio_service/audio_service.dart';
import 'package:blue_music_player/services/song_handler.dart';
import 'package:flutter/material.dart';

class PlayerPlayPauseButton extends StatelessWidget {
  // SongHandler instance to control playback
  final SongHandler songHandler;

  // Size of the button
  final double size;

  // Constructor to initialize the PlayPauseButton
  const PlayerPlayPauseButton({
    super.key,
    required this.size,
    required this.songHandler,
  });

  // Build method to create the widget
  @override
  Widget build(BuildContext context) {
    // StreamBuilder listens to changes in the playback state
    return StreamBuilder<PlaybackState>(
      stream: songHandler.playbackState.stream,
      builder: (context, snapshot) {
        // Check if there's data in the snapshot
        if (snapshot.hasData) {
          // Retrieve the playing status from the playback state
          bool playing = snapshot.data!.playing;

          // Return an IconButton that toggles play/pause on press
          return InkWell(
            highlightColor: Colors.transparent, // رنگ Highlight
            radius: 14,
            onTap: () {
              // Toggle play/pause based on the current playing status
              if (playing) {
                songHandler.pause();
              } else {
                songHandler.play();
              }
            },
            // Display a play or pause icon based on the playing status
            child: playing
                ? Icon(Icons.pause_circle_filled_rounded, size: size)
                : Icon(Icons.play_circle_fill_rounded, size: size),
          );
        } else {
          // If there's no data in the snapshot, return an empty SizedBox
          return const SizedBox.shrink();
        }
      },
    );
  }
}
