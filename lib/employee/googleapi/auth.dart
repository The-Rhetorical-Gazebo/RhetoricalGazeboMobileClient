import 'package:google_sign_in/google_sign_in.dart';
import "package:googleapis_auth/auth_io.dart";
import "package:http/http.dart" as http;
import "package:flutter_dotenv/flutter_dotenv.dart";
import "../utilities/localStorage.dart" as localStorage;

Future<void> loginWithGoogle() async {
  var clientId = dotenv.env["GOOGLE_CLIENT_ID"];
  var id = ClientId(clientId!, "...");
  var scopes = [
    "https://www.googleapis.com/auth/documents",
    "https://www.googleapis.com/auth/drive"
  ];
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: scopes);
  var result = await _googleSignIn.signIn();
  var googleKey = await result!.authentication;
  print("Google token: ${googleKey.accessToken}");
  await localStorage.writeToLocalStorage(
      "google_access_token", googleKey.accessToken);
}

Future<void> logoutFromGoogle() async {
  var clientId = dotenv.env["GOOGLE_CLIENT_ID"];
  var id = ClientId(clientId!, "...");
  var scopes = [
    "https://www.googleapis.com/auth/documents",
    "https://www.googleapis.com/auth/drive"
  ];
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: scopes);
  await _googleSignIn.signOut();
  await localStorage.writeToLocalStorage(
      "google_access_token", null);
}
