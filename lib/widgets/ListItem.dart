import "package:flutter/material.dart";
import "../functions/parsers.dart";
import "Article.dart";

Widget compressedArticle(Map<String, dynamic> content, BuildContext context, double fontFactor) {
  return InkWell(
    onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Article(
                date: content["date"],
                article_id: content["_id"],
                title: content["title"],
                genre: content["genre"],
                subtitle: content["subtitle"],
                author: content["author"],
                image_link: content["image_link"] != null
                    ? content["image_link"]
                    : "https://therhetoricalgazebo-media.s3.us-east-2.amazonaws.com/default.jpg",
                text: convertText(content["content"])))),
    child: Column(children: [
      Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            content["image_link"] != null
                ? content["image_link"]!
                : "https://therhetoricalgazebo-media.s3.us-east-2.amazonaws.com/default.jpg",
            fit: BoxFit.cover,
          ),
        ),
        height: 133 * .9,
        width: 200 * .9,
      ),
      const SizedBox(height: 2.5),
      Text(content["title"],
          style: TextStyle(fontSize: fontFactor* 13, fontWeight: FontWeight.bold)),
      Text(content["subtitle"],
          style: TextStyle(
              fontSize: fontFactor*12, fontWeight: FontWeight.w500, color: Colors.grey)),
    ]),
  );
}

Widget buildListItem(Map<String, dynamic> content1,
    Map<String, dynamic> content2, BuildContext context, double fontFactor) {
  return Padding(
      padding: const EdgeInsets.fromLTRB(4.0, 5, 4.0, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          compressedArticle(content1, context, fontFactor),
          SizedBox(width: 10),
          compressedArticle(content2, context, fontFactor) 
        ],
      ));
}
