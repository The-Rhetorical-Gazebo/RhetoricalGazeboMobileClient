import "package:flutter/material.dart";

Widget shadowContainer(Widget child, double height, double width) {
  return Container(
    alignment: Alignment.center,
    child: child,
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 3,
          blurRadius: 2,
        ),
      ],
    ),
  );
}
