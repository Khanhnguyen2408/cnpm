import 'package:music_app/data/model/song.dart';
import 'package:music_app/data/source/source.dart';
abstract interface class Repository {
  Future<List<Song>?> loadData();
}
class DefaultRepository implements Repository {
  final _localDataSource = LocalDataSource();

  @override
  Future<List<Song>?> loadData() async {
    try {
      final localSongs = await _localDataSource.loadData();
      if (localSongs != null) {
        print("Lấy dữ liệu local thành công: ${localSongs.length} bài hát");
        return localSongs;
      } else {
        print("Không tìm thấy dữ liệu local");
      }
    } catch (e) {
      print("Lỗi khi load dữ liệu local: $e");
    }
    return null;
  }
}
