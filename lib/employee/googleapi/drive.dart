import '../utilities/localStorage.dart';
import "package:http/http.dart" as http;
import "./utils.dart";
import "dart:convert";

Future<dynamic> getAllDocuments() async {
  try {
    String query =
        querystring({"q": "mimeType='application/vnd.google-apps.document'"});
    var url = Uri.parse("https://www.googleapis.com/drive/v3/files?" + query);
    var token = await readFromLocalStorage("google_access_token");
    var testResponse =
        await http.get(url, headers: {"Authorization": "Bearer $token"});
    return json.decode(testResponse.body)["files"];
  } catch (err) {
    print("Error retrieving documents from google drive: $err");
    return null;
  }
}

Future<List<dynamic>> loadDocumentContent(googleDocId) async {
  try {
    var url =
        Uri.parse("https://docs.googleapis.com/v1/documents/$googleDocId");
    var token = await readFromLocalStorage("google_access_token");
    var response =
        await http.get(url, headers: {"Authorization": "Bearer $token"});
    var document = json.decode(response.body);
    var body = document["body"]["content"];
    return body;
  } catch (err) {
    print("Failed to parse google document $googleDocId: $err");
    return [];
  }
}
