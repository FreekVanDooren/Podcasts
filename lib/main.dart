import 'package:flutter/material.dart';
import 'package:podcasts/audio/audio.dart';
import 'package:podcasts/audio/now_playing_screen.dart';
import 'package:podcasts/model/episode.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Podcasts',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(title: 'Start playing'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabs = <PodcastTab>[
      NowPlayingScreen(AudioPlayer(Episode(
          podcastName: 'Hidden Brain',
          title: 'Alan Alda Wants Us To Have Better Conversations',
          duration: Duration(milliseconds: 3185215),
          url:
              'https://play.podtrac.com/npr-510308/npr.mc.tritondigital.com/NPR_510308/media/anon.npr-mp3/npr/hiddenbrain/2018/11/20181119_hiddenbrain_the_edge_of_gender_november_19_rebroadcast_mix.mp3',
          imageUrl:
              'https://is4-ssl.mzstatic.com/image/thumb/Music118/v4/30/30/42/30304274-0382-7142-1922-eebe911156fd/source/100x100bb.jpg')
      )),
      PlayListScreen(),
      SubscriptionsScreen(),
      SearchScreen()
    ];
    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
            appBar: AppBar(
                title: Text(title),
                centerTitle: true,
                bottom: TabBar(
                    tabs: tabs
                        .map((tab) => Tab(icon: Icon(tab.icon)))
                        .toList(growable: false))),
            body: TabBarView(
              children: tabs,
            )));
  }
}

class PlayListScreen extends StatelessWidget implements PodcastTab {
  @override
  Widget build(BuildContext context) {
    return Icon(icon);
  }

  @override
  get icon => Icons.playlist_play;
}

class SubscriptionsScreen extends StatelessWidget implements PodcastTab {
  @override
  Widget build(BuildContext context) {
    return Icon(icon);
  }

  @override
  get icon => Icons.subscriptions;
}

class SearchScreen extends StatelessWidget implements PodcastTab {
  @override
  Widget build(BuildContext context) {
    return Icon(icon);
  }

  @override
  get icon => Icons.search;
}

abstract class PodcastTab implements Widget {
  get icon;
}
