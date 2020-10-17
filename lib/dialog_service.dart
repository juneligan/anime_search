import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'anime_details_screen.dart';

class DialogService {
  static Future<String> createAlertDialog(BuildContext context, Episode episode, String dialogText, String buttonText) {
    TextEditingController customController = TextEditingController();

    return showDialog(context: context, builder: (context) {
      DateTime date = episode.aired != null ? DateTime.parse(episode.aired) : null;
      String formattedDate = date == null ?  '--'
                          : '${getMonth(date.month)} ${date.day} ${date.year}';
      String enTitle = episode.title != null ? '(${episode.title})' : '';
      String jpTitle = episode.japaneseTitle != null ? '${episode.japaneseTitle}' : '';
      String filler = episode.filler ? 'Yes' : 'No';
      return AlertDialog(
          title: Text(dialogText),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            //position
            mainAxisSize: MainAxisSize.min,
            // wrap content in flutter
            children: <Widget>[
              Text("Episode Number : ${episode.id}"),
              Text("Title : $jpTitle $enTitle"),
              Text("Date Aired : $formattedDate"),
              Text("Filler : $filler"),
            ],
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(customController.text.toString());
              },
              elevation: 5.0,
              child: Text(buttonText),
            )
          ]
      );
    });
  }

  static String getMonth(int monthIndex) {
    var  months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[monthIndex-0];
  }
}


