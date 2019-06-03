import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:podcasts/model/episode.dart';

class AudioPlayer {
  final audioPlayer = audio.AudioPlayer()
    ..setReleaseMode(audio.ReleaseMode.STOP);

  bool _isPlaying = false;
  bool _hasStarted = false;

  final episode;

  AudioPlayer(this.episode) {
    audioPlayer.durationHandler = (duration) => print("Duration is ${duration.inMilliseconds}");
    audioPlayer.errorHandler = (message) => print("Player error: $message");
    audioPlayer.completionHandler = () {
      _isPlaying = false;
    };
  }

  bool get isPlaying => _isPlaying;
  get duration => episode.duration;
  get imageUrl => episode.imageUrl;
  get podcastName => episode.podcastName;
  get title => episode.title;
  get durationInMilliseconds => episode.durationInMilliseconds;

  set onPositionChanged(positionHandler(Duration position)) {
    audioPlayer.positionHandler = (Duration position) {
      if (position <= duration) {
        positionHandler(position);
      }
    };
  }

  set position(Duration pos) {
    if (_hasStarted) {
      audioPlayer.seek(pos);
    }
  }

  play({@required onSuccess(), @required onFailure(String msg)}) async =>
      _invokePlayer(
          () async => audioPlayer.play(await episode.path, isLocal: true), () {
        _isPlaying = true;
        _hasStarted = true;
        onSuccess();
      }, (result) => onFailure("Oh Oh, can't play: $result"));

  stop({@required onSuccess(), @required onFailure(String msg)}) async =>
      _invokePlayer(audioPlayer.stop, () {
        _isPlaying = false;
        _hasStarted = false;
        onSuccess();
      }, (result) => onFailure("Oh Oh, can't stop: $result"));

  pause({@required onSuccess(), @required onFailure(String msg)}) async =>
      await _invokePlayer(audioPlayer.pause, () {
        _isPlaying = !_isPlaying;
        onSuccess();
      }, (result) => onFailure("Oh Oh, can't pause: $result"));

  Future _invokePlayer(
      Future<int> future(), onSuccess(), onError(int result)) async {
    final result = await future();
    if (result == 1) {
      onSuccess();
    } else {
      onError(result);
    }
  }
}
