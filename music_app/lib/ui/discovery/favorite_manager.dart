import 'package:music_app/data/model/song.dart';

class FavoriteManager {
  static final FavoriteManager _instance = FavoriteManager._internal();
  factory FavoriteManager() => _instance;
  FavoriteManager._internal();

  final List<Song> _favoriteSongs = [];

  List<Song> get favoriteSongs => _favoriteSongs;

  void addSong(Song song) {
    if (!_favoriteSongs.any((s) => s.id == song.id)) {
      _favoriteSongs.add(song);
    }
  }

  void removeSong(Song song) {
    _favoriteSongs.removeWhere((s) => s.id == song.id);
  }

  bool isFavorite(Song song) {
    return _favoriteSongs.any((s) => s.id == song.id);
  }
}
