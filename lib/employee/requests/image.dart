import "package:dio/dio.dart";
import 'dart:async';
import "package:http/http.dart" as http;
import "dart:io";
import "package:http_parser/http_parser.dart";
import "../utilities/localStorage.dart" as localStorage;
import "package:flutter_dotenv/flutter_dotenv.dart";

var dio = Dio();
Future<String> uploadImage(File image) async {
  try {
    String uri = dotenv.env["domain"]! + "/api/uploads/image";
    String local_token =
        await localStorage.readFromLocalStorage("x-auth-token");
    print("LOCAL_TOKEN: $local_token");
    print("FILEPATH: " + image.path);
    FormData formData = new FormData.fromMap({
      "file": await MultipartFile.fromFile(
        image.path,
        filename: image.path,
        //TODO figure out the actual type of the files
        contentType: MediaType('image', 'jpeg'),
      ),
      'record': null
    });
    Map<String, dynamic> headers = {"x-auth-token": local_token};
    print("Sending post request to: " + uri);
    var response = await dio.post(uri,
        data: formData,
        options: Options(
            headers: headers,
            ));
    print(response.data);
    return response.data["image"]["Location"];
  } catch (err) {
    print("Ran Into Error! uploadImage => " + err.toString());
    return "";
  }
  return "";
}
