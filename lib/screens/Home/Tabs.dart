import 'package:flutter/material.dart';

class SongsTab extends StatefulWidget {
  const SongsTab({super.key});

  @override
  State<SongsTab> createState() => _SongsTabState();
}

class _SongsTabState extends State<SongsTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Songs',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class PlaylistsTab extends StatefulWidget {
  @override
  State<PlaylistsTab> createState() => _PlaylistsTabState();
}

class _PlaylistsTabState extends State<PlaylistsTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Playlists',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}