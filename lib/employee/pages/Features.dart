/**
 * Author: Aparna Dulal
 * profile: https://github.com/ambikadulal
  */
import "package:flutter/material.dart";
import "../utilities/widgets.dart";
import "dart:io";
import "package:cached_network_image/cached_network_image.dart";
import "Home.dart";
import "../requests/articles.dart";
import "../utilities/Article.dart";

//TODO: Store documents using google doc id as well
class EditPage extends StatefulWidget {
  dynamic document;
  dynamic documents;
  dynamic documentsIndex;
  dynamic uploadsSuccessful;
  //pass to last document
  Map<String, Map<String, dynamic>>? documentsToUpload;
  EditPage(
      {Key? key,
      @required this.document,
      @required this.documents,
      @required this.documentsIndex,
      @required this.documentsToUpload,
      this.uploadsSuccessful});
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  bool isFeatured = false;
  String genre = "";
  Map<String, TextEditingController> submissionValues = {};
  bool showPassword = false;
  bool isNetworkImage = false;
  String? filepath;
  Map<String, Map<String, dynamic>> runningDocs = {};
  Widget articleImage = Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
          border: Border.all(width: 4, color: Colors.white),
          boxShadow: [
            BoxShadow(
                spreadRadius: 2,
                blurRadius: 10,
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0, 10))
          ],
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset("assets/image.jpg").image)));
  void imageCallback(String imageLink, {isLocal = true}) {
    if (isLocal) {
      setState(() {
        isNetworkImage = false;
        filepath = imageLink;
        Image localImage = Image.file(File(imageLink));
        articleImage = Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
                border: Border.all(width: 4, color: Colors.white),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0, 10))
                ],
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.cover, image: localImage.image)));
      });
    } else {
      setState(() {
        isNetworkImage = true;
        filepath = imageLink;
        articleImage = CachedNetworkImage(
          imageUrl: imageLink,
          imageBuilder: (context, imageProvider) {
            return Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                    border: Border.all(width: 4, color: Colors.white),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0, 10))
                    ],
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: imageProvider,
                    )));
          },
          placeholder: (context, url) => Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              border: Border.all(width: 4, color: Colors.white),
              boxShadow: [
                BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 10))
              ],
              shape: BoxShape.circle,
            ),
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              border: Border.all(width: 4, color: Colors.white),
              boxShadow: [
                BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 10))
              ],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error),
          ),
        );
      });
    }
    print("NETWORK IMAGE: $isNetworkImage");
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      runningDocs = widget.documentsToUpload!;
      submissionValues = {
        "title": new TextEditingController(),
        "subtitle": new TextEditingController(),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            //go back one docoument
            if (widget.documentsIndex > 0)
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPage(
                        document: widget.documents
                            .elementAt(widget.documentsIndex - 1),
                        documents: widget.documents,
                        documentsIndex: widget.documentsIndex - 1,
                        documentsToUpload: runningDocs),
                  ));
            else {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => EmployeeHome()));
            }
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              onPressed: () {},
              child: Text(
                "SKIP",
                style: TextStyle(
                    fontSize: 14, letterSpacing: 2.2, color: Colors.black),
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                widget.document["name"],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    articleImage,
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Colors.white,
                            ),
                            color: Colors.black,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              showStoragePopup(context, imageCallback);
                              //set image (popup with )
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              buildTextField(
                  "Article Title",
                  "Hitchhiker's Guide to the Galaxy",
                  false,
                  "title",
                  submissionValues["title"]!),
              buildTextField("Subtitle (optional) ", "Don't panic!", false,
                  "subtitle", submissionValues["subtitle"]!),
              GenreDropdown(
                  selectionCallback: (value) {
                    setState(() {
                      genre = value;
                    });
                  },
                  chosenValue: genre == "" ? null : genre),
              YesNoButton(
                  labelText: "Is this Article Featured?",
                  articleSettingsCallback: (yesOrNo) {
                    if (yesOrNo == "YES") {
                      setState(() {
                        isFeatured = true;
                      });
                    } else if (yesOrNo == "NO") {
                      setState(() {
                        isFeatured = false;
                      });
                    }
                  }),
              //TODO: maybe use token/password for each employee to access article

              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlineButton(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      //go to home page
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => EmployeeHome()));
                    },
                    child: Text("CANCEL",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      //send request to post article (put in queue or directly insert it)
                      //then move to next one or return to home page
                      //TODO: still need backend to perform this
                      Map<String, dynamic> submissionVal = new Map.fromIterable(
                          submissionValues.keys,
                          key: (k) => k,
                          value: (k) => submissionValues[k]!.text);
                      submissionVal["googleDocId"] = widget.document["id"];
                      submissionVal['isFeatured'] = isFeatured;
                      submissionVal["genre"] = genre;
                      if (filepath != null) {
                        if (isNetworkImage) {
                          submissionVal["image"] = filepath!;
                        } else {
                          submissionVal["image"] = File(filepath!);
                        }
                        submissionVal["image_is_local"] = !isNetworkImage;
                      }
                      runningDocs[widget.document["id"]] = submissionVal;

                      if (widget.documentsIndex >=
                          widget.documents.length - 1) {
                        //no more documents
                        //upload here, then show whether post is successful or not
                        postArticles(runningDocs).then((success) {
                          success
                              ? Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EmployeeHome(
                                            uploadFailure: false,
                                          )))
                              : Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EmployeeHome(
                                            uploadFailure: true,
                                          )));
                          ;
                        });
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPage(
                                  document: widget.documents
                                      .elementAt(widget.documentsIndex + 1),
                                  documents: widget.documents,
                                  documentsIndex: widget.documentsIndex + 1,
                                  documentsToUpload: runningDocs),
                            ));
                      }
                    },
                    color: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText,
      String placeholder,
      bool isPasswordTextField,
      String tag_name,
      TextEditingController new_controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText),
        Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 35),
          child: TextFormField(
            controller: new_controller,
            obscureText: isPasswordTextField ? showPassword : false,
            decoration: InputDecoration(
                suffixIcon: isPasswordTextField
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: Colors.grey,
                        ),
                      )
                    : null,
                contentPadding: EdgeInsets.only(bottom: 3),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: placeholder,
                hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                    color: Colors.black.withOpacity(.9))),
          ),
        ),
      ],
    );
  }
}
