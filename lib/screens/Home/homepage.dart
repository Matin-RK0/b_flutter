import 'package:blue_music_player/notifiers/songs_provider.dart';
import 'package:blue_music_player/screens/Home/Tabs.dart';
import 'package:blue_music_player/screens/Home/player_deck.dart';
import 'package:blue_music_player/services/song_handler.dart';
import 'package:blue_music_player/screens/Home/songs_list.dart';
import 'package:blue_music_player/screens/search/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.songHandler});
  final SongHandler songHandler;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AutoScrollController autoScrollController = AutoScrollController();
  // Method to scroll to a specific index in the song list
  void _scrollTo(int index) {
    autoScrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.middle,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SongsProvider>(builder: (context, songsProvider, _) {
      return DefaultTabController(
        length: 2,
        child: Consumer<SongsProvider>(
        builder: (context, songsProvider, _) {
          // Scaffold widget for the app structure
          return Scaffold(
            appBar: AppBar(
              title: const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text("Blue Music"),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: IconButton(
                    onPressed: () => Get.to(
                      () => SearchScreen(songHandler: widget.songHandler),
                      duration: const Duration(milliseconds: 700),
                      transition: Transition.rightToLeft,
                    ),
                    icon: const Icon(
                      Icons.search_rounded,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: PopupMenuButton(itemBuilder: (context){
                    return [
                      const PopupMenuItem(child: Text('1')),
                      const PopupMenuItem(child: Text('2')),
                      const PopupMenuItem(child: Text('3')),
                    ];
                  }),
                ),
              ],
              bottom: TabBar(
                  splashFactory: NoSplash.splashFactory,
                  indicatorWeight: 4,
                  indicatorColor: Colors.blue,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorPadding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: -2.0),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white30,
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  tabs: [
                    const SongsTab(),
                    PlaylistsTab(),
                  ],
                ),
            ),
            body: songsProvider.isLoading
                ? _buildLoadingIndicator() // Display a loading indicator while songs are loading
                : _buildSongsList(songsProvider), // Display the list of songs
          );
        },
      ),
      );
    });
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        strokeCap: StrokeCap.round,
      ),
    );
  }

  Widget _buildSongsList(
      SongsProvider songsProvider) {
    return Stack(
      children: [
        // SongsList widget to display the list of songs
        SongsList(
          songHandler: widget.songHandler,
          songs: songsProvider.songs,
          autoScrollController: autoScrollController,
        ),
        _buildPlayerDeck(), // PlayerDeck widget for music playback controls
      ],
    );
  }

  Widget _buildPlayerDeck() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // PlayerDeck widget with controls and the ability to scroll to a specific song
        PlayerDeck(
          songHandler: widget.songHandler,
          isLast: false,
          onTap: _scrollTo,
        ),
      ],
    );
  }
}
