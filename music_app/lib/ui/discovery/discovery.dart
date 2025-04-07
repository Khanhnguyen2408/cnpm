import 'package:flutter/material.dart';
import 'package:music_app/data/model/song.dart';

class DiscoveryTab extends StatelessWidget {
  final List<Song> favoriteSongs;
  const DiscoveryTab({super.key, required this.favoriteSongs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Album Yêu Thích")),
      body: favoriteSongs.isEmpty
          ? Center(child: Text("Chưa có bài hát yêu thích"))
          : ListView.builder(
              itemCount: favoriteSongs.length,
              itemBuilder: (context, index) {
                final song = favoriteSongs[index];
                return ListTile(
                  leading: Image.network(song.image, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(song.title),
                  subtitle: Text(song.artist),
                  trailing: Icon(Icons.favorite, color: Colors.red),
                ); 
              },
            ),
    );
  }
}