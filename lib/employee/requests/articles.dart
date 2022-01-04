import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:http/http.dart" as http;
import "dart:convert";
import "./image.dart";
import "../utilities/localStorage.dart" as localStorage;
import "../googleapi/drive.dart";
import "dart:io";

Future<bool> _postArticle(Map<String, dynamic> fields) async {
  try {
    //TODO: return error-specific message as string

    List<dynamic> content = await loadDocumentContent(fields["googleDocId"]);
    Map<String, dynamic> final_fields = fields;
    String? author = await localStorage.readFromLocalStorage("name");
    final_fields["content"] = content;
    final_fields["name"] = author == null ? "Anonymous" : author;
    Uri uri = Uri.parse(dotenv.env["domain"]! + "/api/articles");
    String local_token =
        await localStorage.readFromLocalStorage("x-auth-token");
    if (final_fields["image_is_local"] != null &&
        final_fields["image_is_local"]) {
      File image = final_fields["image"];
      String image_link = await uploadImage(image);
      if (image_link == "") {
        print("Failed to upload image.");
        return false;
      }
      final_fields["image_link"] = image_link;
    }
    final_fields["image"] = null;
    http.Response response = await http.post(uri,
        body: json.encode({"fields": final_fields}),
        headers: {
          "x-auth-token": local_token,
          "Content-Type": "application/json"
        });
    print("Article post response: ${response.body}");
    if (json.decode(response.body).containsKey("error")) {
      throw ErrorDescription((json.decode(response.body)["error"].toString()));
    }
    if (json.decode(response.body).containsKey("msg")) {
      if (json.decode(response.body)["msg"] == "Token is not valid") {
        throw ErrorDescription(
            "Error: Invalid Token ==> Need to prompt user for login if token is invalid.");
        return false;
      }
    }

    return true;
  } catch (err) {
    print("Error uploading article: $err");
    return false;
  }
}

Future<bool> postArticles(Map<String, Map<String, dynamic>> fields) async {
  try {
    for (var i in fields.values) {
      bool success = await _postArticle(i);
      if (!success) {
        return false;
      }
    }
    return true;
  } catch (err) {
    print("Error uploading article: $err");
    return false;
  }
}
