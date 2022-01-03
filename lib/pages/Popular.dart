import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import "../widgets/ListItem.dart";

Color getColor(String genre) {
  switch (genre) {
    case "Politics":
      return Colors.amber;
    case "Actual News":
      return Colors.black;
    case "Creative Writing and Satire":
      return Colors.green;
    case "Sports":
      return Colors.red;
    case "Books and Film":
      return Colors.blue;
    case "Opinion":
      return Colors.purple;
    default:
      return Colors.white;
  }
}

class PopularArticles extends StatelessWidget {
  List<dynamic>? popular_articles;
  BuildContext? context;
  PopularArticles(
      {@required this.popular_articles, @required this.context, Key? key})
      : super(key: key);
  List<Widget> articles_by_genre = [];
  void build_column(articles) {
    Map<String, dynamic> by_genre = {
      "Politics": [],
      "Creative Writing and Satire": [],
      "Politics": [],
      "Books and Film": [],
      "Opinion": [],
      "Actual News": [],
    };
    for (int i = 0; i < articles.length; i++) {
      by_genre[articles[i]["genre"]].add(articles[i]);
    }
    int iter = 0;
    bool genre_to_add = true;
    while (genre_to_add) {
      genre_to_add = false;
      for (int i = 0; i < by_genre.keys.length; i++) {
        String key = by_genre.keys.toList()[i];
        if (by_genre[key].length > iter) {
          genre_to_add = true;
          //add up to next two as row with background
          if (by_genre[key].length - iter == 1) {
            //center article
            articles_by_genre.add(Container(
              color: getColor(key).withOpacity(.2), 
              height: MediaQuery.of(context!).size.height * 0.3,
              alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    compressedArticle(by_genre[key][iter], context!, 1.25),
                  ],
                )));
          } else {
            //use buildListItem
            articles_by_genre.add(Container(
             color: getColor(key).withOpacity(.2),
              alignment: Alignment.center,
              height: MediaQuery.of(context!).size.height / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildListItem(
                      by_genre[key][iter], by_genre[key][iter + 1], context!, 1.25
                      ),
                ],
              ),
            ));
          }
        }
      }
      iter += 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    build_column(popular_articles!);
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text("Popular Articles"),
            centerTitle: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context))),
        body: SingleChildScrollView(
          child: Column(
            children: articles_by_genre,
          ),
        ));
  }
}
