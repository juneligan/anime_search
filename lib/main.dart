import 'dart:convert';
import 'dart:io';

import 'package:anime_search/list_view_service.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() {
  http.Client httpClient = http.Client();
  runApp(MyApp(httpClient));
}

class MyApp extends StatelessWidget {

  MyApp(this.httpClient);

  final http.Client httpClient;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', httpClient: httpClient,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.httpClient}) : super(key: key);
  final String title;
  final http.Client httpClient;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Anime> searchResults = [];
  TextEditingController customController = TextEditingController();
  Widget searchResultWidget = Text('Result');
  int narutoAnimationIndex = 0;
  int narutoIndex = 1;
  String narutoAnimation = '';

  void _incrementCounter(BuildContext context) {
    searchResultWidget = Container(
      child: FlareActor(
        'assets/searching.flr',
        alignment: Alignment.center,
        fit: BoxFit.none,
        animation: 's2',
      ),
    );
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    String searchString = customController.text.toString();
    if (searchString.isEmpty) {
      return;
    }
    String getQueryString = 'https://private-anon-f55a253521-jikan.apiary-proxy.com/v3/search/anime?q=${customController.text.toString()}&page=1&limit=15';
    widget.httpClient.get(getQueryString)
    .then((response) {
      Map<String, dynamic> json = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Anime> results = (json['results'] as List<dynamic>)
          .map((dynamic item) => Anime.fromJson(item as Map<String, dynamic>))
          .toList();
      setState(() {
        _counter++;
        searchResults.clear();
        searchResults.addAll(results);

        searchResultWidget = results.length > 0
            ? ListViewService.getMatchedItemsListView(searchResults, widget.httpClient)
            : Text('NO SEARCH RESULTS');// Container(child: Image.asset('assets/naruto_cri.gif'));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      height: 270,
                      child: FlareActor(
                        'assets/naruto_smirking.flr',
                        alignment: Alignment.center,
                        fit: BoxFit.fitWidth,
                        animation: narutoAnimation,
                      ),
                    )
                  ),
                  Positioned(
                      left: 0,
                      right: 0,
                      height: 100,
                      child: Container(
                        height: 45,
                        child: FlareActor(
                          'assets/anime_search_bar.flr',
                          alignment: Alignment.center,
                          fit: BoxFit.fitWidth,
                          animation: 'right tap',
                        ),
                      )
                  ),
                  Container(
                    height: 110,
                    padding: const EdgeInsets.only(left: 60.0, right: 0.0),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: <Widget>[
                        FlatButton(onPressed: () => _incrementCounter(context), child: Text("Search")),
                        Expanded(child:
                        TextField(
                            autocorrect: false,
                            decoration: InputDecoration(
                                border: InputBorder.none,
//                                hintText: 'Enter a search term'
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            controller: customController,
                            onChanged: (text) {
                              print(text);
                              setState(() {

                                if (text.length == 0 && narutoIndex == 1) {
                                  narutoIndex = narutoIndex + 1;
                                  narutoAnimation = '1+';
                                } else if (text.length == 8  && narutoIndex == 2) {
                                  narutoIndex = narutoIndex + 1;
                                  narutoAnimation = '2+';
                                } else if (text.length == 8 && narutoIndex == 3) {
                                  narutoAnimation = '2-';
                                  narutoIndex = narutoIndex - 1;
                                } else if (text.length == 0 && narutoIndex == 2) {
                                  narutoAnimation = '1-';
                                  narutoIndex = narutoIndex - 1;
                                }
                              });

                            },
                        ),)
                      ],
                    ),
                  ),
                  Container(),
                ],
              ),
//              Flexible(child: )
              ListViewService.getMatchedItemsListView(searchResults, widget.httpClient),
//              searchResultWidget
              ],
        ),
    );
  }
}

class Anime {
  int id;
  String title;
  String url;
  String imageUrl;
  int episodes;
  String score;

  Anime({this.id, this.title, this.url, this.imageUrl, this.episodes, this.score});

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['mal_id'],
      title: json['title'],
    );
  }
}
