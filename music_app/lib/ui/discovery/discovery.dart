import 'package:flutter/material.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/ui/discovery/favorite_manager.dart';
import 'package:music_app/ui/now_playing/playing.dart';

class FavoriteAlbumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Song> favoriteSongs = FavoriteManager().favoriteSongs;

    return Scaffold(
      appBar: AppBar(title: Text('Album yêu thích')),
      body: favoriteSongs.isEmpty
          ? Center(child: Text("Chưa có bài hát yêu thích"))
          : ListView.builder(
              itemCount: favoriteSongs.length,
              itemBuilder: (context, index) {
                final song = favoriteSongs[index];
                return ListTile(
                  leading: Image.network(song.image, width: 50, height: 50, errorBuilder: (_, __, ___) => Icon(Icons.music_note)),
                  title: Text(song.title),
                  subtitle: Text(song.artist),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NowPlaying(
                          playingSong: song,
                          songs: favoriteSongs,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
