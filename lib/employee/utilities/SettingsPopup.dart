import "package:flutter/material.dart";
import 'package:gazebo/pages/Home.dart';
import "dart:ui";
import "../auth/choice.dart";

Color invertColor(Color c) {
  String util = c.toString();
  if (util.contains("MaterialColor")) {
    util = "Color(0x" + util.substring(util.length - 10, util.length - 2) + ")";
  }
  int r = int.parse(util.substring(10, 12), radix: 16);
  int g = int.parse(util.substring(12, 14), radix: 16);
  int b = int.parse(util.substring(14, 16), radix: 16);
  int o = int.parse(util.substring(8, 10), radix: 16);
  return Color.fromRGBO(255 - r, 255 - g, 255 - b, (o / 255));
}

Widget NavButton(Widget child, Widget page, Color color, BuildContext context) {
  return Container(
    child: ClipOval(
      child: Material(
        color: color, // Button color
        child: InkWell(
          splashColor: invertColor(color), // inkwell color
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          ),
        ),
      ),
    ),
  );
}

void SettingsPopup(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Dialog(
                insetPadding: EdgeInsets.all(0),
                backgroundColor: Colors.white.withOpacity(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NavButton(
                        Image.asset("assets/logo.png",
                            scale: 8, color: Colors.white),
                        Choice(),
                        Colors.black,
                        context),
                    NavButton(Icon(Icons.home, size: 35, color: Colors.white),
                        Home(), Colors.blue, context),
                  ],
                )));
      });
}
