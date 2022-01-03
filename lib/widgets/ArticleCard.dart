import "package:flutter/material.dart";
import 'package:gazebo/functions/parsers.dart';
import "Article.dart";

class ArticleCard extends StatelessWidget {
  Map<String, dynamic>? article_content;
  ArticleCard({@required this.article_content,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9 * MediaQuery.of(context).size.width / 10,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Article(
                          date: article_content!["date"],
                          article_id: article_content!["_id"],
                          title: article_content!["title"],
                          genre: article_content!["genre"],
                          subtitle: article_content!["subtitle"],
                          author: article_content!["author"],
                          image_link: article_content!["image_link"],
                          text: convertText(article_content!["content"]))));
            },
            child: Container(
              //TODO: Consider limiting height of card
              child: Image.network(article_content!["image_link"] != null
                  ? article_content!["image_link"]
                  : "https://therhetoricalgazebo-media.s3.us-east-2.amazonaws.com/default.jpg"),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Title(
              color: Colors.black,
              child: Text(article_content!["title"],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:  MediaQuery.of(context).size.width / 18))),
        ),
        Text(article_content!["subtitle"],
            style: TextStyle(color: Colors.grey, fontSize: 14)),
        Divider(color: Colors.grey)
      ]),
    );
  }
}
