import 'dart:convert';

import 'package:anime_search/list_view_service.dart';
import 'package:anime_search/main.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class AnimeDetailsScreen extends StatefulWidget {
  final String title;
  final Anime animeDetails;
  final http.Client httpClient;
  AnimeDetailsScreen({Key key, this.title, this.animeDetails, this.httpClient}) : super(key: key);

  @override
  _AnimeDetailsScreenState createState() => _AnimeDetailsScreenState();
}


class _AnimeDetailsScreenState extends State<AnimeDetailsScreen> {
  List<Episode> episodes = [];
  Widget bodyWidget = Text('LOADING');

  @override
  void initState() {

    bodyWidget = Container(
      child: FlareActor(
        'assets/searching.flr',
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: 's2',
      ),
    );

    widget.httpClient.get('https://api.jikan.moe/v3/anime/${widget.animeDetails.id}/episodes')
        .then((response) {
//      print('---------->>>1');
//      print(jsonEncode(jsonDecode(response.body)));
//      print('---------->>>2');
      Map<String, dynamic> json = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Episode> results = (json['episodes'] as List<dynamic>)
          .map((dynamic item) => Episode.fromJson(item as Map<String, dynamic>))
          .toList();
      setState(() {
        episodes.addAll(results);
        bodyWidget = results.length > 0
            ? ListViewService.getAnimeEpisodesListView(episodes)
            : Container(child: Image.asset('assets/naruto_cri.gif'));
      });
    });
  }
  @override
  Widget build(BuildContext context) {

    String title = widget.animeDetails.title;
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(title),
      ),
      body: bodyWidget,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class Episode {
  int id;
  String title;
  String japaneseTitle;
  String aired;
  bool filler;

  Episode({this.id, this.title, this.japaneseTitle, this.aired, this.filler});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['episode_id'],
      title: json['title'],
      japaneseTitle: json['title_japanese'],
      aired: json['aired'],
      filler: json['filler'],
    );
  }
}
