import 'package:audio_service/audio_service.dart';
import 'package:blue_music_player/utils/formatted_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongItem extends StatelessWidget {
  final MediaItem mediaItem;
  final String? searchedWord;
  final bool isPlaying;
  final Uri? art;
  final String title;
  final String? artist;
  final int id;
  final VoidCallback onSongTap;

  // Constructor for the SongItem class
  const SongItem({
    super.key,
    required this.isPlaying,
    required this.title,
    required this.artist,
    required this.onSongTap,
    required this.id,
    this.searchedWord,
    required this.art,
    required this.mediaItem,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6),
      child: ListTile(
        // Set tile color based on whether the song is playing
        //tileColor: isPlaying
        //? Theme.of(context).colorScheme.primary.withOpacity(0.25)
        //: null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        // Handle tap on the ListTile
        onTap: () => onSongTap(),
        // Build leading widget (artwork)
        leading: _buildLeading(context, mediaItem),
        // Build title and subtitle widgets
        title: _buildTitle(context),
        subtitle: _buildSubtitle(context, mediaItem),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return searchedWord != null
        ? formattedText(
            corpus: title,
            searchedWord: searchedWord!,
            context: context,
          )
        : Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.fade,
          );
  }

  // Build the subtitle widget with optional search word formatting
  Text? _buildSubtitle(BuildContext context, MediaItem song) {
    return artist == null
        ? null
        : searchedWord != null
            ? formattedText(
                corpus: artist!,
                searchedWord: searchedWord!,
                context: context,
              )
            : Text(
                formatDuration(context, song),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
  }

  String formatDuration(BuildContext context, MediaItem song) {
    return artist!; ' . ' +
        '${song.duration?.inMinutes.remainder(60).toString().padLeft(2, '0')}:${song.duration?.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  // Build the leading widget (artwork)
  Widget _buildLeading(BuildContext context, MediaItem playingSong) {
    return Container(
      height: 56,
      width: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: QueryArtworkWidget(
        // Artwork for the leading box
        id: int.parse(playingSong.displayDescription!),
        type: ArtworkType.AUDIO,
        size: 500,
        quality: 100,
        artworkBorder: BorderRadius.circular(14.0),
        nullArtworkWidget: const Center(
          child: Icon(Icons.music_note_rounded),
        ),
        errorBuilder: (p0, p1, p2) => const Icon(Icons.music_note_rounded),
      ),
    );
  }
}
