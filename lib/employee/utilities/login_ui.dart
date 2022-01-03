import 'package:flutter/material.dart';

final kHintTextStyle = TextStyle(
  color: Colors.black.withOpacity(.4),
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);
final kLabelStyleMax = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
  decoration: TextDecoration.underline,
);
final kLabelStyleMin = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.w400,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
