import "package:flutter/material.dart";
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getStyle(bool bold, bool italics, bool underline) {
  if (bold && !italics && !underline) {
    return TextStyle(
        fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16.5);
  } else if (bold && italics && !underline) {
    return TextStyle(
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        color: Colors.black,
        fontSize: 16.5);
  } else if (bold && italics && underline) {
    return TextStyle(
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        decoration: TextDecoration.underline,
        color: Colors.black,
        fontSize: 16.5);
  } else if (!bold && italics && underline) {
    return TextStyle(
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.italic,
        decoration: TextDecoration.underline,
        color: Colors.black,
        fontSize: 16.5);
  } else if (!bold && !italics && underline) {
    return TextStyle(
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.underline,
        color: Colors.black,
        fontSize: 16.5);
  } else if (!bold && !italics && !underline) {
    return TextStyle(
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        color: Colors.black,
        fontSize: 16.5);
  } else if (bold && !italics && underline) {
    return TextStyle(
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.underline,
        color: Colors.black,
        fontSize: 16.5);
  } else if (!bold && italics && !underline) {
    return TextStyle(
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.italic,
        color: Colors.black,
        fontSize: 16.5);
  } else {
    return TextStyle(color: Colors.black, fontSize: 16.5);
  }
}

RichText convertText(String content) {
  List<TextSpan> sequential_text = [];
  bool in_markers = false;
  bool bold = false;
  bool italics = false;
  bool underline = false;
  String substring = "";
  bool start_marker = true;
  for (int i = 0; i < content.length; i++) {
    if (content[i] == "*") {
      if (!in_markers) {
        if (!start_marker) {
          //just finished interating through substring
          //add textspan
          sequential_text.add(TextSpan(
              text: substring, style: getStyle(bold, italics, underline)));
          bold = false;
          italics = false;
          underline = false;
        }
        in_markers = true;
      } else {
        if (!start_marker) {
          substring = "";
        }
        start_marker = !start_marker;
        in_markers = false;
      }
    } else if (in_markers && start_marker) {
      if (content[i] == 'b') {
        bold = true;
      } else if (content[i] == 'i') {
        italics = true;
      } else if (content[i] == 'u') {
        underline = true;
      }
    } else {
      if (content[i] == '\t') {
        substring+= "     ";
      }
      else {
        substring += content[i];
      }
    }
  }
  return RichText(
      text: TextSpan(
          children: sequential_text,
          style: GoogleFonts.merriweather(
              textStyle: TextStyle(height: 1.5, fontWeight: FontWeight.w300))));
}
