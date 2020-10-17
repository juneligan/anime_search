import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:anime_search/main.dart';
import 'package:mockito/mockito.dart';


class MockHttpClient extends Mock implements http.Client {}

void main() {
  final httpClient = MockHttpClient();

  testWidgets('MyApp should input a text to the search input text field', (WidgetTester tester) async {
    given:
    String searchString = "Fate/Zero";
    String getQueryString = 'https://private-anon-f55a253521-jikan.apiary-proxy.com/v3/search/anime?q=$searchString&page=1&limit=15';
    await tester.pumpWidget(MyApp(httpClient));

    before:
    expect(find.text('Fate/Zero 2nd Season'), findsNothing);

    expect(find.byType(TextField), findsOneWidget);
    await tester.pump(Duration(milliseconds:400));
    await tester.enterText(find.byType(EditableText), searchString);
    
    var response = {
      "request_hash": "request:search:56fac16417cf9e7fb9cfd05b73a29d4e04e57ecf",
      "request_cached": true,
      "request_cache_expiry": 189093,
      "results": [
      {
        "mal_id": 11741,
        "title": "Fate/Zero 2nd Season",
      },]
    };

    when(httpClient.get(getQueryString)).thenAnswer((_) async => http.Response(jsonEncode(response), 200));

    when:
    await tester.tap(find.byType(RaisedButton));
    await tester.pump();

    expect(find.text('Fate/Zero 2nd Season'), findsOneWidget);
  });

  testWidgets('MyApp should navigate to the anime\'s episode page when tapping one of the search results', (WidgetTester tester) async {
    given:
    int animeId = 11741;
    String getEpisodeQueryString = 'https://api.jikan.moe/v3/anime/$animeId/episodes';
    String searchString = "Fate/Zero";
    String getQueryString = 'https://private-anon-f55a253521-jikan.apiary-proxy.com/v3/search/anime?q=$searchString&page=1&limit=15';
    await tester.pumpWidget(MyApp(httpClient));

    before:
    expect(find.text('Fate/Zero 2nd Season'), findsNothing);

    expect(find.byType(TextField), findsOneWidget);
    await tester.pump(Duration(milliseconds:400));
    await tester.enterText(find.byType(EditableText), searchString);

    final animeSearchResponse = {
      "request_hash": "request:search:56fac16417cf9e7fb9cfd05b73a29d4e04e57ecf",
      "request_cached": true,
      "request_cache_expiry": 189093,
      "results": [
        {
          "mal_id": animeId,
          "title": "Fate/Zero 2nd Season",
        },]
    };

    final enTitle1 = "Above Aoi";
    final jpTitle1 = "Test 1";
    final listTitle1 = 'Ep 1 - $jpTitle1 ($enTitle1)';

    final enTitle2 = "Expression of Hatred";
    final jpTitle2 = "Test 2";
    final listTitle2 = 'Ep 2 - $jpTitle2 ($enTitle2)';
    final episodesSearchResponse = {
      "episodes": [ {
        "episode_id": 1,
        "title": "$enTitle1",
        "title_japanese": "$jpTitle1",
        "aired": "2008-10-06T00:00:00+00:00",
        "filler": false,
      },{
        "episode_id": 2,
        "title": "$enTitle2",
        "title_japanese": "$jpTitle2",
        "aired": "2008-10-13T00:00:00+00:00",
        "filler": false,
      },]
    };

    when(httpClient.get(getQueryString)).thenAnswer((_) async => http.Response(jsonEncode(animeSearchResponse), 200));
    when(httpClient.get(getEpisodeQueryString)).thenAnswer((_) async => http.Response(jsonEncode(episodesSearchResponse), 200));

    when:
    await tester.tap(find.byType(RaisedButton));
    await tester.pump(Duration(milliseconds:400));

    await tester.tap(find.text('Fate/Zero 2nd Season'));
    await tester.pumpAndSettle(Duration(milliseconds:400));

    then:
    expect(find.text(listTitle1), findsOneWidget);
    expect(find.text(listTitle2), findsOneWidget);
  });

  testWidgets('MyApp should navigate to the anime\'s episode page when tapping one of the search results', (WidgetTester tester) async {
    given:
    int animeId = 11741;
    String getEpisodeQueryString = 'https://api.jikan.moe/v3/anime/$animeId/episodes';
    String searchString = "Fate/Zero";
    String getQueryString = 'https://private-anon-f55a253521-jikan.apiary-proxy.com/v3/search/anime?q=$searchString&page=1&limit=15';
    await tester.pumpWidget(MyApp(httpClient));

    before:
    expect(find.text('Fate/Zero 2nd Season'), findsNothing);

    expect(find.byType(TextField), findsOneWidget);
    await tester.pump(Duration(milliseconds:400));
    await tester.enterText(find.byType(EditableText), searchString);

    final animeSearchResponse = {
      "request_hash": "request:search:56fac16417cf9e7fb9cfd05b73a29d4e04e57ecf",
      "request_cached": true,
      "request_cache_expiry": 189093,
      "results": [
        {
          "mal_id": animeId,
          "title": "Fate/Zero 2nd Season",
        },]
    };

    final enTitle1 = "Above Aoi";
    final jpTitle1 = "Test 1";
    final listTitle1 = 'Ep 1 - $jpTitle1 ($enTitle1)';

    final enTitle2 = "Expression of Hatred";
    final jpTitle2 = "Test 2";
    final listTitle2 = 'Ep 2 - $jpTitle2 ($enTitle2)';
    final episodesSearchResponse = {
      "episodes": [ {
        "episode_id": 1,
        "title": "$enTitle1",
        "title_japanese": "$jpTitle1",
        "aired": "2008-10-06T00:00:00+00:00",
        "filler": false,
      },{
        "episode_id": 2,
        "title": "$enTitle2",
        "title_japanese": "$jpTitle2",
        "aired": "2008-10-13T00:00:00+00:00",
        "filler": false,
      },]
    };
    String episodeNumber = "Episode Number : 1";
    String titleDetail = "Title : $jpTitle1 ($enTitle1)";
    String airedDetail = "Date Aired : Jun 06 2008";
    String fillerDetail = "Filler : No";

    when(httpClient.get(getQueryString)).thenAnswer((_) async => http.Response(jsonEncode(animeSearchResponse), 200));
    when(httpClient.get(getEpisodeQueryString)).thenAnswer((_) async => http.Response(jsonEncode(episodesSearchResponse), 200));

    when:
    await tester.tap(find.byType(RaisedButton));
    await tester.pump(Duration(milliseconds:400));

    await tester.tap(find.text('Fate/Zero 2nd Season'));
    await tester.pumpAndSettle(Duration(milliseconds:400));

    expect(find.text(listTitle1), findsOneWidget);
    await tester.tap(find.text(listTitle1));
    await tester.pumpAndSettle(Duration(milliseconds:400));

    then:
    expect(find.text(episodeNumber), findsOneWidget);
    expect(find.text(titleDetail), findsOneWidget);
    expect(find.text(fillerDetail), findsOneWidget);
  });
}
