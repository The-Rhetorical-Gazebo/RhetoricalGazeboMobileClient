/**
 * Author: Damodar Lohani
 * profile: https://github.com/lohanidamodar
  */

import 'package:flutter/material.dart';
import "../pages/requests/requests.dart";
import "../pages/Genre.dart";
import "package:google_fonts/google_fonts.dart";
import 'package:intl/date_symbol_data_local.dart';
import "package:intl/intl.dart";
import "package:bordered_text/bordered_text.dart";

class Article extends StatelessWidget {
  Map<String, Widget> genre_icons = {
    //Map icons to genres here
  };
  String? title;
  String? date;
  String? subtitle;
  String? genre;
  String? author;
  String? image_link;
  String? article_id;
  bool first_build = true;
  RichText? text = RichText(
      text: TextSpan(children: [
    TextSpan(
        text:
            'This article is missing its appropriate text. Please contact therhetoricalgazebo@gmail.com.',
        style: TextStyle(color: Colors.black, height: 1.5)),
  ]));

  //add images later
  Article(
      {required this.title,
      this.subtitle,
      required this.article_id,
      required this.genre,
      required this.author,
      required this.date,
      required this.text,
      required this.image_link,
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    if (first_build) {
      add_click(article_id!);
      first_build = false;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        title: Text(title!),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height * 0.36,
                    width: double.infinity,
                    child: Image.network(
                      image_link != null
                          ? image_link!
                          : 'https://therhetoricalgazebo-media.s3.us-east-2.amazonaws.com/default.jpg',
                      fit: BoxFit.cover,
                    )),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.03,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GenrePage(genre: genre!)));
                    },
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 15),
                        BorderedText(
                          strokeColor: Colors.grey,
                          strokeWidth: 1.0,
                          child: Text(
                            genre!,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Icon(Icons.slideshow, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(DateFormat.yMMMMd('en_US')
                            .format(DateTime.parse(date!))),
                      ),
                      IconButton(
                        icon: Icon(Icons.share, color: Colors.transparent),
                        onPressed: () {},
                      )
                    ],
                  ),
                  Row(children: [
                    Text(subtitle!,
                        style: TextStyle(fontStyle: FontStyle.italic)),
                    SizedBox(width: 2.5),
                    Text("by"),
                    SizedBox(width: 2.5),
                    Text(author!, style: TextStyle(fontWeight: FontWeight.w500))
                  ]),
                  Divider(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: Text(title!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.merriweather(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.height / 32.5)),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height/50),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: text!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
