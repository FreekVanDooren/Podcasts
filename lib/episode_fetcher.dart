import 'package:http/http.dart' as HttpClient;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:podcasts/model/episode.dart';

class EpisodeFetcher {
  fetch(Episode episode) async {
    final appDir = (await getApplicationDocumentsDirectory()).path;
    final podcast = episode.podcastName.replaceAll(RegExp(r'\s'), '').toLowerCase();
    final episodeName = episode.title.replaceAll(RegExp(r'\s'), '').toLowerCase();
    final path = '$appDir/$podcast/$episodeName.mp3';
    final mp3File = File(path);
    if (!mp3File.existsSync()) {
      print("Have to download now");
      await mp3File.create(recursive: true);
      final response = await HttpClient.get(episode.url);
      await mp3File.writeAsBytes(response.bodyBytes);
    }
    return path;
  }
}
