import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gazebo/employee/googleapi/auth.dart';
import 'package:gazebo/employee/utilities/SettingsPopup.dart';
import "package:http/http.dart";
import "../googleapi/drive.dart";
import "../utilities/widgets.dart";
import "Features.dart";
import "../auth/login.dart";
import "package:flutter/services.dart";
import "dart:math" as math;
import "../utilities/localStorage.dart" as localStorage;
import "../requests/token.dart";
import "../auth/choice.dart";
import "package:pull_to_refresh/pull_to_refresh.dart";

//TODO: Show list of documents and press one to post to gazebo
class EmployeeHome extends StatefulWidget {
  bool? uploadFailure;
  EmployeeHome({Key? key, this.uploadFailure}) : super(key: key);
  @override
  _EmployeeHomeState createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {
  bool? showSnackbar = false;
  SpinKitWave spinner = SpinKitWave(color: Colors.black, size: 50.0);
  bool loading = true;
  bool isAdmin = false;
  List<DocumentTile> documentTiles = [];
  List<dynamic> documents = [];
  Set<dynamic> docsToUpload = {};
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    init().then((args) {
      setState(() {
        loading = false;
      });
      _refreshController.refreshCompleted();
    });
  }

  void showSuccessSnackbar() {
    WidgetsBinding.instance!.addPostFrameCallback(
        (_) => showSuccess(context, "Documents uploaded successfully"));
  }

  void showFailureSnackbar() {
    WidgetsBinding.instance!.addPostFrameCallback((_) => showError(context,
        "Failed to upload documents. Please\nensure all required fields are entered."));
  }

  Future<void> init() async {
    try {
      await loginWithGoogle();
      List<dynamic> documentsUtil = await getAllDocuments();
      documentsUtil.sort((a, b) => a["name"].compareTo(b["name"]));
      bool isAdminUtil = await localStorage.readFromLocalStorage("admin");
      setState(() {
        documentTiles = [];
        isAdmin = isAdminUtil;
        documents = documentsUtil;
        for (int i = 0; i < documents.length; i++) {
          var doc = documents[i];
          DocumentTile tile = DocumentTile(
              onTap: () {
                //remove if already tapped
                if (docsToUpload.contains(documents[i])) {
                  docsToUpload.remove(documents[i]);
                } else {
                  docsToUpload.add(documents[i]);
                }
              },
              text: doc["name"]);
          documentTiles.add(tile);
        }
      });
    } catch (err) {
      print("Error initializing home page: $err");
    }
  }

  @override
  void initState() {
    super.initState();
    init().then((value) {
      setState(() {
        loading = false;
      });
    });
    setState(() {
      showSnackbar = widget.uploadFailure;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: spinner),
      );
    } else {
      if (showSnackbar != null && !showSnackbar!) {
        showSuccessSnackbar();
        setState(() {
          showSnackbar = null;
        });
      }
      if (showSnackbar != null && showSnackbar!) {
        showFailureSnackbar();
        setState(() {
          showSnackbar = null;
        });
      }
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                signOutUserWidget(context);
              },
              icon: Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                child: Transform(
                  child: Icon(Icons.logout),
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                ),
              ),
            ),
            actions: [
              isAdmin
                  ? IconButton(
                      icon: Icon(Icons.vpn_key),
                      onPressed: () async {
                        //get referral token
                        String? token = await getAdminReferralToken();
                        if (token != null) {
                          showSuccess(context, token + " (Copied)",
                              milliseconds: 10000);
                          Clipboard.setData(ClipboardData(text: token));
                        } else {
                          showError(context,
                              "Your referral token could not be generated. Try logging in again or closing the app.",
                              milliseconds: 10000);
                        }
                      })
                  : Container(),
              IconButton(
                icon: Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  //set details (genre, isFeatured, etc.) in next page
                  //make sure more than 0
                  if (docsToUpload.length > 0) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPage(
                            document: docsToUpload.elementAt(0),
                            documents: docsToUpload,
                            documentsIndex: 0,
                            documentsToUpload: {},
                          ),
                        ));
                  } else {
                    showError(
                        context, "Select at least one document for upload.");
                  }
                },
              ),
              SizedBox(width: 5)
            ],
            title: Text("Document Upload"),
            centerTitle: true,
            backgroundColor: Colors.black,
          ),
          body: Stack(
            children: [
              SmartRefresher(
                enablePullDown: true,
                header: WaterDropHeader(
                    complete: Icon(Icons.check, color: Colors.green)),
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: () {},
                child: ListView(
                  children: [
                    Center(
                        child: Stack(
                      children: [
                        SingleChildScrollView(
                            child: Column(
                                children: documentTiles.length > 0
                                    ? documentTiles
                                    : [
                                        Text(
                                            "No documents were found. If this is incorrect, try refreshing the page by pulling down. Otherwise, create a google document and get to writing content!")
                                      ])),
                      ],
                    ))
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FloatingActionButton(
                      backgroundColor: Colors.black,
                      onPressed: () {
                        SettingsPopup(context);
                      },
                      child: Image.asset("assets/logo.png",
                          scale: 11, color: Colors.white)),
                ),
              )
            ],
          ));
    }
  }
}
