import 'dart:math';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/ui/now_playing/audio_player_manager.dart';

List<Song> _favoriteSongs = [];
class NowPlaying extends StatelessWidget {
  const NowPlaying({super.key, required this.playingSong, required this.songs});
  final Song playingSong;
  final List<Song> songs;
  @override
  Widget build(BuildContext context) {
    return NowPlayingPage(songs: songs, playingSong: playingSong);
  }
}

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({
    super.key,
    required this.playingSong,
    required this.songs,
  });
  final Song playingSong;
  final List<Song> songs;

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _imageAnimationController;
  late AudioPlayerManager _audioPlayerManager;
  late int _selectedItemIndex;
  late Song _song;
  late double _currentAnimationPosition;
  bool _isShuffle = false;
  late LoopMode _loopMode;
  bool _isFavorite = false;
  @override
  void initState() {
    super.initState();
    _song=widget.playingSong;
    _currentAnimationPosition=0.0;
    _imageAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
    _audioPlayerManager = AudioPlayerManager();
    _audioPlayerManager.updateSongUrl(_song.source);
    _audioPlayerManager.init();
    _selectedItemIndex = widget.songs.indexOf(widget.playingSong);
    _loopMode = LoopMode.off;
  }

  @override
  Widget build(BuildContext context) {
    //return const Scaffold(body: Center(child: Text('Now Playing')));
    final screenWidth =
        MediaQuery.of(context).size.width; // lấy thôngông số màn hình
    const delta = 64;
    final radius = (screenWidth - delta) / 2;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Now Playing'),
        trailing: IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
      ),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Text(_song.album),
              const SizedBox(height: 16),
              const Text('_ ___ _'),
              const SizedBox(height: 48),
              RotationTransition(
                turns: Tween(
                  begin: 0.0,
                  end: 1.0,
                ).animate(_imageAnimationController),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/itune.png',
                    image: _song.image,
                    //luu yy
                    width: 100,
                    height: 100,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/itune.png',
                        //luu yy
                        width: 100,
                        height: 100,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 64, bottom: 16),
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.share_outlined),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Column(
                        children: [
                          Text(
                            _song.title,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _song.artist,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          _setFavorite();
                        },
                        icon: Icon(Icons.favorite_outline),
                        color: _getFavoriteColor(),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 16),
                child: _progressBar(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 16),
                child: _mediaButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose(){
    _imageAnimationController.dispose();
    super.dispose();
  }
  //tao _progressBar
  StreamBuilder<DurationState> _progressBar(){
    return StreamBuilder<DurationState>(
      stream: _audioPlayerManager.durationState, 
      builder: (context, snapshot){
        final durationState = snapshot.data;
        final progress = durationState?.progress??Duration.zero;
        final buffered = durationState?.buffered??Duration.zero;
        final total = durationState?.total??Duration.zero;
        return ProgressBar(
          progress: progress, 
          total: total,
          buffered: buffered,
          onSeek: _audioPlayerManager.player.seek,
          barHeight: 5.0,
          barCapShape: BarCapShape.round,
          baseBarColor: Colors.grey,
          progressBarColor: Colors.deepPurple,
          bufferedBarColor: Colors.grey.shade300,
          );
      }
    );
  }
  //nut play button
  StreamBuilder <PlayerState> _playButton(){
    return StreamBuilder(
      stream: _audioPlayerManager.player.playerStateStream, 
      builder: (context, snapshot){
        final playState = snapshot.data;
        final processingState = playState?.processingState;
        final playing = playState?.playing;
        if(processingState == ProcessingState.loading 
        || processingState == ProcessingState.buffering){
          return Container(
            margin: EdgeInsets.all(8),
            width: 40,
            height: 40,
            child: CircularProgressIndicator(),
          );
        } else if(playing != true){
          return MediaButtonControl(
            function: (){
              _audioPlayerManager.player.play();
              _imageAnimationController.forward(from: _currentAnimationPosition);
              _imageAnimationController.repeat();
            }, 
            icon: Icons.play_arrow, 
            color: null, 
            size: 48
            );
        }else if(processingState != ProcessingState.completed){
          return MediaButtonControl(
            function: (){
              _audioPlayerManager.player.pause();
              _imageAnimationController.stop();
              _currentAnimationPosition=_imageAnimationController.value;
            }, 
            icon: Icons.pause, 
            color: null, 
            size: 48
            );
        }else{
          if(processingState == ProcessingState.completed){
            _imageAnimationController.stop();
            _currentAnimationPosition = 0.0;
          }
          return MediaButtonControl(
            function: (){
              _audioPlayerManager.player.seek(Duration.zero);
              _currentAnimationPosition = 0.0;
              _imageAnimationController.forward(from: _currentAnimationPosition);
              _imageAnimationController.repeat();
            }, 
            icon: Icons.replay, 
            color: null, 
            size: 48
            );
        }
      }
      );
  }

  void setNextSong(){
    if(_isShuffle){
      var random = Random();
      _selectedItemIndex = random.nextInt(widget.songs.length);
    }else if(_selectedItemIndex<widget.songs.length - 1){
      ++_selectedItemIndex;
    }
    else if(_loopMode == LoopMode.all && _selectedItemIndex ==  widget.songs.length - 1){
      _selectedItemIndex = 0;
    }
    if(_selectedItemIndex >= widget.songs.length){
      _selectedItemIndex = _selectedItemIndex % widget.songs.length;
    }
    final nextSong = widget.songs[_selectedItemIndex];
    _imageAnimationController.stop();
    _audioPlayerManager.updateSongUrl(nextSong.source);
    _currentAnimationPosition = 0.0;
    _imageAnimationController.forward(from: _currentAnimationPosition);
    setState(() {
      _song = nextSong;
    });
  }
  void setPrevSong(){
    if(_isShuffle){
      var random = Random();
      _selectedItemIndex = random.nextInt(widget.songs.length);
    }else if(_selectedItemIndex>0){
      --_selectedItemIndex;
    }else if(_loopMode == LoopMode.all && _selectedItemIndex == 0){
      _selectedItemIndex = widget.songs.length -1;
    }
    if(_selectedItemIndex < 0){
      _selectedItemIndex = (-1*_selectedItemIndex) % widget.songs.length;
    }
    final nextSong = widget.songs[_selectedItemIndex];
    _imageAnimationController.stop();
    _audioPlayerManager.updateSongUrl(nextSong.source);
    _currentAnimationPosition = 0.0;
    _imageAnimationController.forward(from: _currentAnimationPosition);
    setState(() {
      _song = nextSong;
    });
  }

  //icon va ham khi nhan vao nut yeu thich
  Color? _getFavoriteColor(){
    return _isFavorite ? Colors.red : Colors.grey;
  }

  void _setFavorite(){
    setState(() {
      _isFavorite = !_isFavorite;
      if(_isFavorite){
        _favoriteSongs.add(_song);
      }else{
        _favoriteSongs.removeWhere((song) => song.id==_song.id);
      }
    });
  }
  //
  void _setShuffle(){
    setState(() {
      _isShuffle = !_isShuffle;
    });
  }


  Color? _getShuffeColor(){
    return _isShuffle ? Colors.deepPurple : Colors.grey;
  }

  IconData _repeatingIcon(){
    return switch(_loopMode){
      LoopMode.one => Icons.repeat_one,
      LoopMode.all => Icons.repeat_on,
      _ => Icons.repeat
    };
  }

  void _setRepeatOption(){
    if(_loopMode == LoopMode.off){
      _loopMode = LoopMode.one;
    }else if(_loopMode == LoopMode.one){
      _loopMode = LoopMode.all;
    }else{
      _loopMode = LoopMode.off;
    }
    setState(() {
      _audioPlayerManager.player.setLoopMode(_loopMode);
    });
  }

  Color? _getReapeatingIconColor(){
    return _loopMode == LoopMode.off ? Colors.grey : Colors.deepPurple;
  }

  // tao MediaButton
  Widget _mediaButtons(){
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MediaButtonControl(function: _setShuffle, icon: Icons.shuffle, color: _getShuffeColor(), size: 24),
          MediaButtonControl(function: setPrevSong, icon: Icons.skip_previous, color: Colors.deepPurple, size: 36),
          _playButton(),
          MediaButtonControl(function: setNextSong, icon: Icons.skip_next, color: Colors.deepPurple, size: 36),
          MediaButtonControl(function: _setRepeatOption, icon: _repeatingIcon(), color: _getReapeatingIconColor(), size: 24)
        ],
      ),
    );
  }
}


class MediaButtonControl extends StatefulWidget{
  const MediaButtonControl({
    super.key,
    required this.function,
    required this.icon,
    required this.color,
    required this.size,
  });
  final void Function()? function;
  final IconData icon;
  final double? size;
  final Color? color;

  @override
  State<StatefulWidget> createState() => _MediaButtonControlState(); 
}

class _MediaButtonControlState extends State<MediaButtonControl>{
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.function, 
      icon: Icon(widget.icon), 
      iconSize: widget.size,
      color: widget.color ?? Theme.of(context).colorScheme.primary,
    );
  }
}