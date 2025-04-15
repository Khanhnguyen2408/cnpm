import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/ui/discovery/favorite_manager.dart';
import 'package:music_app/ui/home/viewmodel.dart';
import 'package:music_app/ui/now_playing/playing.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  List<Song> allSongs = [];
  List<Song> filteredSongs = [];

  final TextEditingController _searchController = TextEditingController();
  late MusicAppViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MusicAppViewModel();
    _viewModel.loadSongs();

    _viewModel.songStream.stream.listen((songList) {
      setState(() {
        allSongs = songList;
        filteredSongs = songList;
      });
    });

    _searchController.addListener(() {
      filterSongs(_searchController.text);
    });
  }

  void filterSongs(String query) {
    final results = allSongs.where((song) {
      final titleLower = song.title.toLowerCase();
      final artistLower = song.artist.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower) || artistLower.contains(searchLower);
    }).toList();

    setState(() => filteredSongs = results);
  }

  void goToNowPlaying(Song song) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => NowPlaying(
          songs: filteredSongs,
          playingSong: song,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: 'Tìm kiếm bài hát...',
              ),
            ),
            Expanded(
              child: Material(
                child: ListView.builder(
                  itemCount: filteredSongs.length,
                  itemBuilder: (context, index) {
                    final song = filteredSongs[index];
                    return ListTile(
                      leading: Image.network(
                        song.image,
                        width: 48,
                        height: 48,
                        errorBuilder: (_, __, ___) => Icon(Icons.music_note),
                      ),
                      title: Text(song.title),
                      subtitle: Text(song.artist),
                      onTap: () => goToNowPlaying(song),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
