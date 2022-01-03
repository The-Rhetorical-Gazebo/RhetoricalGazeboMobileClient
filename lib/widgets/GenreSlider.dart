import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import "./ArticleCard.dart";
import "package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart";
import "ListItem.dart";
Widget genreRow(String genre, List<dynamic> genre_content, BuildContext context) {
  List<Widget> genre_row = genre_content
      .map((element) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: compressedArticle(element, context, 1.5),
      ))
      .toList();
  return Column(
    children: [
    Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(genre.toUpperCase(),
            style: TextStyle(fontSize: MediaQuery.of(context).size.height/37.5,
             fontWeight: FontWeight.bold)),
      ),
    ),
    Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height/4,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Center(
          child: Row(
            children: genre_row),
        ))
    ),
  ]);
}
