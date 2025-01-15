import 'package:audio_service/audio_service.dart';
import 'package:blue_music_player/notifiers/songs_provider.dart';
import 'package:blue_music_player/screens/Home/player_deck.dart';
import 'package:blue_music_player/screens/Home/songitem.dart';
import 'package:blue_music_player/screens/Player/player.dart';
import 'package:blue_music_player/services/song_handler.dart';
import 'package:blue_music_player/utils/formatted_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class SongsList extends StatelessWidget {
  final List<MediaItem> songs;
  final SongHandler songHandler;
  final AutoScrollController autoScrollController;

  const SongsList({
    super.key,
    required this.songs,
    required this.songHandler,
    required this.autoScrollController,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            // به دست آوردن نمونه از SongsProvider
            final songsProvider =
                Provider.of<SongsProvider>(context, listen: false);
            // بارگیری و به‌روزرسانی لیست اهنگ‌ها
            await songsProvider.loadSongs(songHandler);
          },
          child: ListView.builder(
            controller: autoScrollController,
            padding: const EdgeInsets.only(top: 5),
            // Build a scrollable list of songs
            itemCount: songs.length,
            itemBuilder: (context, index) {
              MediaItem song = songs[index];

              // Build the SongItem based on the playback state
              return StreamBuilder<MediaItem?>(
                stream: songHandler.mediaItem.stream,
                builder: (context, snapshot) {
                  MediaItem? playingSong = snapshot.data;

                  // Check if the current item is the last one
                  return index == (songs.length - 1)
                      ? _buildLastSongItem(context, song, playingSong)
                      : AutoScrollTag(
                          // Utilize AutoScrollTag for automatic scrolling
                          key: ValueKey(index),
                          controller: autoScrollController,
                          index: index,
                          child:
                              _buildRegularSongItem(context, song, playingSong),
                        );
                },
              );
            },
          ),
        ),
        const Center(
          child: Text('Not ready'),
        ),
      ],
    );
  }

  Widget _buildLastSongItem(
      BuildContext context, MediaItem song, MediaItem? playingSong) {
    return Column(
      children: [
        // Display the last song item
        SongItem(
          id: int.parse(song.displayDescription!),
          isPlaying: song == playingSong,
          title: formattedTitle(song.title),
          artist: song.artist,
          onSongTap: () async {
            await songHandler.skipToQueueItem(songs.length - 1);
          },
          art: song.artUri,
          mediaItem: song,
        ),
        // Display the player deck for controls
        PlayerDeck(
          songHandler: songHandler,
          isLast: true,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildRegularSongItem(
      BuildContext context, MediaItem song, MediaItem? playingSong) {
    return SongItem(
      id: int.parse(song.displayDescription!),
      isPlaying: song == playingSong,
      title: formattedTitle(song.title),
      artist: song.artist,
      onSongTap: () async {
        await songHandler.skipToQueueItem(songs.indexOf(song));
        Get.to(
          () => Player(
            songHandler: songHandler,
            isLast: true, songsProvider: SongsProvider(),
          ),
          duration: const Duration(microseconds: 700),
          transition: Transition.cupertino,
        );
      },
      art: song.artUri,
      mediaItem: song,
    );
  }
}
