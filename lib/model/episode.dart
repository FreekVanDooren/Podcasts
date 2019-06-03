import '../episode_fetcher.dart';

class Episode {
  final String podcastName;
  final String title;
  final String url;
  final String imageUrl;
  final Duration duration;
  String _path;

  Episode({this.podcastName, this.title, this.url, this.imageUrl, this.duration});

  Future<String> get path async {
    if (_path == null) {
      _path = await EpisodeFetcher().fetch(this);
    }
    return _path;
  }

  @override
  String toString() => "Episode[podcast=$podcastName, title=$title, duration=$duration]";

  get durationInMilliseconds => duration?.inMilliseconds?.toDouble() ?? 0.0;
}