import "package:flutter/material.dart";
import "RoundedContainer.dart";
import "Article.dart";
import "dart:async";
import "package:flutter/services.dart";
import 'dart:ui' as ui;
import "BlurredText.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:bordered_text/bordered_text.dart";

class FeaturedNews extends StatelessWidget {
  //TODO: Consider adding description to display with featured news (image too)
  String? title;
  String? subtitle;
  String? author;
  String? image_link;
  dynamic onTap;

  List<double> getShadowWidth(data, List<double> dimensions) {
    double ratio;
    if (data.height > data.width) {
      //Scale height and width according to height
      ratio = data.height / dimensions[1];
    } else {
      //Scale width
      ratio = data.width / dimensions[0];
    }
    return [data.width / ratio, data.height / ratio];
  }

  //add images later
  FeaturedNews(
      {@required this.title,
      @required this.image_link,
      this.subtitle,
      @required this.author,
      @required this.onTap,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Image im_widget = Image.network(image_link != null
        ? image_link!
        : "https://therhetoricalgazebo-media.s3.us-east-2.amazonaws.com/default.jpg");
    Completer<ui.Image> completer = new Completer<ui.Image>();
    im_widget.image
        .resolve(new ImageConfiguration())
        .addListener(new ImageStreamListener((ImageInfo image, bool _) {
      completer.complete(image.image);
    }));
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: GestureDetector(
          onTap: onTap,
          child: Column(children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.only(bottom: 20),
                child: Stack(alignment: Alignment.center, children: [
                  im_widget,
                  new FutureBuilder<ui.Image>(
                    future: completer.future,
                    builder: (BuildContext context,
                        AsyncSnapshot<ui.Image> snapshot) {
                      if (snapshot.hasData) {
                        List<double> dim = getShadowWidth(snapshot.data, [
                          MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.width * 0.6
                        ]);

                        print(snapshot.data);
                        return shadowContainer(
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * .05),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: BorderedText(
                                  strokeWidth: 1.0,
                                  strokeColor: Colors.grey,
                                  child: Text(
                                    title!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            dim[1],
                            dim[0]);
                      } else {
                        return SpinKitHourGlass(
                          color: Colors.black,
                          size: 50,
                        );
                      }
                    },
                  ),
                ]))
          ])),
    );
  }
}
