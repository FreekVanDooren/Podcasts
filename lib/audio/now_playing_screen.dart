import 'package:flutter/material.dart';
import 'package:podcasts/main.dart';
import 'package:podcasts/audio/audio.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NowPlayingScreen extends StatefulWidget implements PodcastTab {
  final player;

  NowPlayingScreen(this.player);

  @override
  State<StatefulWidget> createState() => NowPlayingScreenState();

  @override
  get icon => Icons.play_arrow;
}

class NowPlayingScreenState extends State<NowPlayingScreen> {

  static const Duration ZERO = Duration(seconds: 0);

  Duration _currentTime = ZERO;

  String _showUser = "Loaded";

  AudioPlayer get _audioPlayer => widget.player;

  @override
  Widget build(BuildContext context) {
    _audioPlayer.onPositionChanged = (Duration position) {
      setState(() {
        _currentTime = position;
      });
    };
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: _audioPlayer.imageUrl,
                    placeholder: CircularProgressIndicator(),
                  ),
                  Text(
                    _audioPlayer.podcastName,
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    _audioPlayer.title,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 48),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    _showUser,
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 20,
            child: Slider(
              activeColor: Theme.of(context).buttonColor,
              min: 0.0,
              max: _audioPlayer.durationInMilliseconds,
              onChanged: (time) => setState(() {
                    _currentTime = Duration(milliseconds: time.toInt());
                    print("Currently at: $time translated to $_currentTime");
                  }),
              value: _currentTime < _audioPlayer.duration ? _currentTime.inMilliseconds.toDouble() : _audioPlayer.durationInMilliseconds,
              onChangeEnd: (time) => setState(() {
                    print("Currently ending at: $time");
                    _audioPlayer.position =
                        Duration(milliseconds: time.toInt());
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: asText(_currentTime),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: asText(_audioPlayer.duration),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _toPreviousButton,
              _rewindButton,
              _audioPlayer.isPlaying ? _pauseButton : _playButton,
              _forwardButton,
              _toNextButton
            ],
          ),
        ],
      ),
    );
  }

  FloatingActionButton get _toPreviousButton => FloatingActionButton(
      onPressed: () => setState(() {
            _showUser = 'To Previous';
            _audioPlayer.stop(
                onSuccess: () => setState(() {
                  _showUser = _showUser + ' and stopped!';
                }),
            onFailure: _onAudioFailure);
            _currentTime = Duration(seconds: 0);
          }),
      tooltip: 'Previous',
      child: Icon(Icons.skip_previous));

  FloatingActionButton get _rewindButton => FloatingActionButton(
      onPressed: () => setState(() {
            _showUser = 'Rewind 10';
            final newTime = calculateNewTime(-10);
            _audioPlayer.position = newTime;
            _currentTime = newTime;
          }),
      tooltip: 'Rewind',
      child: Icon(Icons.replay_10));

  FloatingActionButton get _playButton => FloatingActionButton(
        onPressed: () async {
          await _audioPlayer.play(
              onSuccess: () => setState(() {
                _showUser = 'Playing';
                if (_currentTime != null) {
                  _audioPlayer.position = _currentTime;
                }
              }),
              onFailure: _onAudioFailure);
        },
        tooltip: 'Play',
        child: Icon(Icons.play_circle_filled),
      );

  FloatingActionButton get _pauseButton => FloatingActionButton(
      onPressed: () async => _audioPlayer.pause(
          onSuccess: () => setState(() {
                _showUser = _audioPlayer.isPlaying ? 'Paused' : _showUser;
              }),
          onFailure: _onAudioFailure),
      tooltip: 'Pause',
      child: Icon(Icons.pause_circle_filled));

  FloatingActionButton get _forwardButton => FloatingActionButton(
      onPressed: () => setState(() {
            _showUser = 'Forward 30';
            final newTime = calculateNewTime(30);
            _audioPlayer.position = newTime;
            _currentTime = newTime;
          }),
      tooltip: 'Forward',
      child: Icon(Icons.forward_30));

  FloatingActionButton get _toNextButton => FloatingActionButton(
      onPressed: () => setState(() {
            _showUser = 'To Next';
          }),
      tooltip: 'Next',
      child: Icon(Icons.skip_next));

  Duration calculateNewTime(int addedSeconds) {
    final newTime = (_currentTime ?? ZERO) + Duration(seconds: addedSeconds);
    if (newTime < ZERO || _audioPlayer.duration == null) {
      return ZERO;
    }

    if (newTime >= _audioPlayer.duration) {
      return _audioPlayer.duration;
    }
    return newTime;
  }

  void _onAudioFailure(msg) {
    print(msg);
    setState(() {
        _showUser = msg;
      });
  }
}

asText(Duration duration) {
  if (duration == null) {
    return Text("0:00:00");
  }
  final seconds = asTimeText(duration.inSeconds);
  final minutes = asTimeText(duration.inMinutes);
  return Text("${duration.inHours}:$minutes:$seconds");
}

String asTimeText(int n) {
  final remains= n.remainder(60);
  return remains < 10 ? "0$remains" : "$remains";
}
