import 'package:audio_service/audio_service.dart';
import 'package:blue_music_player/notifiers/songs_provider.dart';
import 'package:blue_music_player/screens/Home/homepage.dart';
import 'package:blue_music_player/screens/Player/player_song_progress.dart';
import 'package:blue_music_player/services/song_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'player_play_pause_button.dart';

class Player extends StatelessWidget {
  final SongHandler songHandler;
  final bool isLast;
  final SongsProvider songsProvider;
  const Player({super.key, required this.songHandler, required this.isLast, required this.songsProvider});
  
  @override
  Widget build(BuildContext context) {
    // Use StreamBuilder to reactively build UI based on changes to the mediaItem stream
    return StreamBuilder<MediaItem?>(
      stream: songHandler.mediaItem.stream,
      builder: (context, snapshot) {
        MediaItem? playingSong = snapshot.data;
        // If there's no playing song, return an empty widget
        return playingSong == null
            ? const SizedBox.shrink()
            : _buildPlayer(context, playingSong, playingSong.duration!,songsProvider);
      },
    );
  }

  Widget _buildPlayer(
      BuildContext context, MediaItem playingSong, Duration totalDuration,SongsProvider songsProvider) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(34, 34, 34, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0x10FFFFFF),
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.offAll(
                          () => HomePage(
                            songHandler: songHandler,
                          ),
                          duration: const Duration(microseconds: 700),
                          transition: Transition.cupertino,
                        );
                      },
                      highlightColor: Colors.transparent, // رنگ Highlight
                      radius: 6,
                      child: Icon(
                        Icons.arrow_back,
                        color: Color(0xffDDDDDD),
                        size: 20,
                      ),
                    ),
                  ),
                  Text(
                    'Now Playing',
                    style: TextStyle(fontSize: 20),
                  ),
                  Icon(
                    Icons.more_vert,
                    size: 28,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(50)),
                  child: QueryArtworkWidget(
                    // Set up artwork properties
                    id: int.parse(playingSong.displayDescription!),
                    type: ArtworkType.AUDIO,
                    size: 500,
                    quality: 100,
                    artworkHeight: double.infinity,
                    artworkWidth: double.infinity,
                    artworkFit: BoxFit.cover,
                    artworkBorder: BorderRadius.circular(16.0),
                    nullArtworkWidget: const Icon(Icons.music_note_sharp),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.left,
                              softWrap: false,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              playingSong.title,
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              textDirection: TextDirection.ltr,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              playingSong.artist!,
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      Icon(CupertinoIcons.heart_fill)
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: PlayerSongProgress(
                            totalDuration: totalDuration,
                            songHandler: songHandler),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 34,
                ),
                SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 100, right: 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                          ),
                          child: InkWell(
                            onTap: () {
                              songHandler.seek(Duration.zero);
                            },
                            onDoubleTap: (){
                              songHandler.skipToPrevious();
                            },
                            highlightColor: Colors.transparent, // رنگ Highlight
                            radius: 10,
                            child: Icon(
                              size: 30,
                              CupertinoIcons.backward_fill,
                              color: Color(0xffDDDDDD),
                            ),
                          ),
                        ),
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                          ),
                          child: PlayerPlayPauseButton(
                            size: 70,
                            songHandler: songHandler,
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                          ),
                          child: InkWell(
                            onTap: () {
                              songHandler.skipToNext();
                            },
                            highlightColor: Colors.transparent, // رنگ Highlight
                            radius: 10,
                            child: Icon(
                              size: 30,
                              CupertinoIcons.forward_fill,
                              color: Color(0xffDDDDDD),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
