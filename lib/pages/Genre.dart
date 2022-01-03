import "package:flutter/material.dart";
import 'package:gazebo/pages/requests/requests.dart';
import "../widgets/ArticleCard.dart";
import "package:http/http.dart" as http;
import "package:flutter_spinkit/flutter_spinkit.dart";

class GenrePage extends StatefulWidget {
  String? genre;
  GenrePage({@required this.genre, Key? key}) : super(key: key);

  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  bool _loading = true;
  List<Widget> widgets = [
    SizedBox(
      width: double.infinity,
    )
  ];
  List<dynamic> genre_content = [];
  Future<void> init() async {
    try {
      List<dynamic> genre_content_util = await get_genre(widget.genre!);
      setState(() {
        genre_content = genre_content_util;
        widgets.addAll(genre_content
                      .map((element) => ArticleCard(article_content: element))
                      .toList());
      });
    } catch (err) {
      print("Error getting articles of genre ${widget.genre}: $err");
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
    return _loading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: SpinKitWanderingCubes(color: Colors.black))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
                title: Text(widget.genre!),
                centerTitle: true,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context))),
            body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widgets),
            ));
  }
}
