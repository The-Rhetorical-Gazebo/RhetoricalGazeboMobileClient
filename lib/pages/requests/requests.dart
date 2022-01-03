import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import "package:flutter_dotenv/flutter_dotenv.dart";
import "dart:convert";

Future<Map<String, dynamic>> get_home_digest() async {
  try {
    Uri uri = Uri.parse(dotenv.env["domain"]! + "/api/articles/digest");
    http.Response response = await http.get(uri);
    Map<String, dynamic> data = json.decode(response.body);
    if (data.containsKey("error")) {
      throw ErrorDescription(data["error"].toString());
    }
    return data["digest"];
  } catch (err) {
    //figure out what to return if response is invalid
    print("Error getting digest articles: $err");
    return {};
  }
}

Future<void> add_click(String article_id) async {
  try {
    Uri uri =
        Uri.parse(dotenv.env["domain"]! + "/api/articles/click/" + article_id);
    http.Response response = await http.put(uri);
    Map<String, dynamic> data = json.decode(response.body);
    if (data["success"] != 1) {
      throw ErrorDescription(
          "Failed to add click to article" + article_id + ".");
    }
    print("Added click to article $article_id.");
  } catch (err) {
    //figure out what to return if response is invalid
    print("Error adding click: $err");
  }
}

Future<dynamic> get_genre(String genre) async {
  try {
    Uri uri = Uri.parse(dotenv.env["domain"]! + "/api/articles/$genre");
    http.Response response = await http.get(uri);
    Map<String, dynamic> data = json.decode(response.body);
    if (data.containsKey("error")) {
      throw ErrorDescription(data["error"].toString());
    }
    return data["${genre}_articles"];
  } catch (err) {
    //figure out what to return if response is invalid
    print("Error getting articles of genre $genre: $err");
    return [];
  }
}

Future<List<Map<String, dynamic>>> getFeaturedArticles() async {
  try {
    Uri uri = Uri.parse(dotenv.env["domain"]! + "/api/articles/featured");
    http.Response response = await http.get(uri);
    Map<String, dynamic> data = json.decode(response.body);
    if (data.containsKey("error")) {
      throw ErrorDescription(data["error"].toString());
    }
    return data["featured"];
  } catch (err) {
    //figure out what to return if response is invalid
    print("Error getting featured articles; $err");
    return [];
  }
}
