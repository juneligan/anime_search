
import 'package:anime_search/anime_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dialog_service.dart';
import 'main.dart';

class ListViewService {
  static Widget getMatchedItemsListView(List items, http.Client httpClient) {
    var listView = ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        var anime = items[index];
        String title = anime.title ?? ''; // TODO remove since this will not gonna happen
        return ListTile(
          leading: Icon(Icons.animation),
          title: Text(title),
          onTap: () => _navigateToAnimeDetails(anime, context, httpClient),
        );
      },
    );
    return listView;
  }

  static Widget getAnimeEpisodesListView(List items) {
    var listView = ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        Episode episode = items[index];

        String enTitle = episode.title != null ? '(${episode.title})' : '';
        String jpTitle = episode.japaneseTitle != null ? '${episode.japaneseTitle}' : '';
        String title = 'Ep ${episode.id} - $jpTitle $enTitle';
        return ListTile(
          title: Text(title),
          onTap: () => _showAddCartDialog(episode, context),
        );
      },
    );
    return listView;
  }

  static _navigateToAnimeDetails(Anime animeDetails, BuildContext context, http.Client httpClient) {
    debugPrint('YOUR CART $animeDetails');
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => AnimeDetailsScreen(animeDetails: animeDetails, httpClient: httpClient,)));
  }

  static void _showAddCartDialog(Episode episode, BuildContext context) {
    print(episode.title);
    print(episode.japaneseTitle);
    print(episode.aired);
    print(episode.filler);
    DialogService.createAlertDialog(context, episode, 'Episode ${episode.id} Details', 'Close')
        .then((value) {});
  }
}
