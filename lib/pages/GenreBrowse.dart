import 'package:flutter/material.dart';
import 'package:gazebo/widgets/GenreSlider.dart';
import "../widgets/ArticleCard.dart";
import "./requests/requests.dart";
import "../functions/getGenres.dart";

class GenreBrowse extends StatefulWidget {
  GenreBrowse({ Key? key}) : super(key: key);

  @override
  State<GenreBrowse> createState() => _GenreBrowseState();
}

class _GenreBrowseState extends State<GenreBrowse> {
  bool _loading = true;
  List<Widget> widgets = [SizedBox(height: 10)];
  Future<void> init() async {
    try {
      List<String> genres = getGenres();
      for (int i = 0; i < genres.length; i++) {
        String genre = genres[i];
        List<dynamic> genre_content_util = await get_genre(genre);

        setState(() {
          widgets.add(genreRow(genre, genre_content_util, context));
        });
      }
    } catch (err) {
      print("Error getting articles for genre browsing}: $err");
    }
  }

  @override
  void initState() {
    init().then((e) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Browse Genres"),
          centerTitle: true,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: widgets,
            ),
          ),
        ));
  }
}
