import 'package:flutter/material.dart';
import "package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart";
import 'package:gazebo/pages/Genre.dart';
import "GenreBrowse.dart";
import "../widgets/RoundedContainer.dart";
import "package:google_fonts/google_fonts.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "./requests/requests.dart";
import "../widgets/FeaturedNews.dart";
import '../widgets/ListItem.dart';
import "../widgets/Article.dart";
import '../functions/parsers.dart';
import "Popular.dart";
import "../employee/auth/choice.dart";

const Color dotInactive = Color(0x33000000);

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> featured_news_widgets = [];
  List<dynamic> popular_content = [];
  Widget popular_column = Column(children: []);
  bool _loading = true;
  Future<void> init() async {
    var digest = await get_home_digest();
    digest["featured"]!.forEach((element) {
      //Convert text to list rich text with text span
      RichText allText = convertText(element["content"]);
      setState(() {
        String image_link = element["image_link"] != null
            ? element["image_link"]
            : "https://therhetoricalgazebo-media.s3.us-east-2.amazonaws.com/default.jpg";
        featured_news_widgets.add(FeaturedNews(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Article(
                        date: element["date"],
                        article_id: element["_id"],
                        title: element["title"],
                        genre: element["genre"],
                        subtitle: element["subtitle"],
                        author: element["author"],
                        image_link: image_link,
                        text: allText))),
            title: element["title"],
            image_link: element["image_link"],
            subtitle: element["subtitle"],
            author: element["author"]));
      });
    });
    List<Widget> pop_content_util = [];
    for (var i = 0; i < digest["popular"].length - 1; i += 2) {
      var element1 = digest["popular"][i];
      var element2 = digest["popular"][i + 1];
      pop_content_util.add(buildListItem(element1, element2, context, 1));
    }
    setState(() {
      popular_content = digest["popular"];
      popular_column = Column(children: pop_content_util);
    });
  }

  @override
  void initState() {
    init().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? SpinKitWanderingCubes(color: Colors.black)
        : Scaffold(
          appBar: AppBar(
            centerTitle: true, 
            backgroundColor: Colors.black,
            leading: IconButton(icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context,MaterialPageRoute(
                          builder: (context) => Choice() ));
            }),
            title: Image.asset(
              "assets/logo.png",
              scale: 10,
              color: Colors.white,
            ),
          ),
            backgroundColor: Colors.white,
            body: ListView(
              children: <Widget>[
                _buildFeaturedNews(),
                _buildHeading("Popular posts", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PopularArticles(
                              popular_articles: popular_content,
                              context: context)));
                }),
                popular_column,
                SizedBox(height: 8.0),
                _buildHeading("Browse by genre", () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GenreBrowse()));
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GenrePage(
                                        genre: "Creative Writing and Satire")));
                          },
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(2.0, 0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Creative Writing and Satire",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(.9))),
                                  Icon(Icons.book,
                                      color: Colors.white.withOpacity(.9))
                                ],
                              ),
                            ),
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GenrePage(genre: "Actual News")));
                          },
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(2.0, 0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Actual News",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(.9))),
                                  Icon(Icons.book,
                                      color: Colors.white.withOpacity(.9))
                                ],
                              ),
                            ),
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GenrePage(genre: "Politics")));
                          },
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(2.0, 0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Politics",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(.9))),
                                  Icon(Icons.book,
                                      color: Colors.white.withOpacity(.9))
                                ],
                              ),
                            ),
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GenrePage(genre: "Sports")));
                          },
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(2.0, 0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Sports",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(.9))),
                                  Icon(Icons.book,
                                      color: Colors.white.withOpacity(.9))
                                ],
                              ),
                            ),
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GenrePage(genre: "Books and Film")));
                          },
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(2.0, 0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Books and Film",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(.9))),
                                  Icon(Icons.book,
                                      color: Colors.white.withOpacity(.9))
                                ],
                              ),
                            ),
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      GenrePage(genre: "Opinion"))),
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(2.0, 0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Opinion",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(.9))),
                                  Icon(Icons.book,
                                      color: Colors.white.withOpacity(.9))
                                ],
                              ),
                            ),
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Padding _buildHeading(String title, Function callback) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withOpacity(0.9)),
              ),
            ),
          ),
          MaterialButton(
            elevation: 0,
            textColor: Colors.white,
            color: Colors.black,
            height: 0,
            child: Icon(Icons.keyboard_arrow_right),
            minWidth: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: const EdgeInsets.all(2.0),
            onPressed: () {
              callback();
            },
          ),
        ],
      ),
    );
  }

  Container _buildFeaturedNews() {
    return Container(
        height: MediaQuery.of(context).size.height * 0.40,
        child: Column(children: [
          SizedBox(height: 5.0),
          Text(
            "Featured News",
            textAlign: TextAlign.center,
            style: TextStyle(
                letterSpacing: 0.75,
                fontSize: 26.0,
                color: Colors.black,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 7.5),
          Expanded(
            child: Swiper(
              layout: SwiperLayout.DEFAULT,
              pagination: const SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                    color: dotInactive,
                    activeColor: Colors.black,
                  ),
                  margin: const EdgeInsets.only()),
              viewportFraction: 0.9,
              autoplay: true,
              itemCount: featured_news_widgets.length,
              loop: true,
              itemBuilder: (context, index) {
                return featured_news_widgets[index];
              },
            ),
          ),
        ]));
  }
}
