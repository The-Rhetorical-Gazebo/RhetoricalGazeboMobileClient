import "package:flutter/material.dart";
import "package:rflutter_alert/rflutter_alert.dart";
import "package:file_picker/file_picker.dart";
import "dart:io";
import "./DropdownTitle.dart";
import "../auth/choice.dart";
import "localStorage.dart" as localStorage;
import "../requests/auth.dart";

class DocumentTile extends StatefulWidget {
  String text;
  Color textColor;
  Color backgroundColor;
  dynamic onTap;
  dynamic parentKey;
  DocumentTile(
      {Key? key,
      this.text = "",
      this.textColor = Colors.black,
      this.backgroundColor = Colors.white,
      this.onTap = null,
      this.parentKey = null})
      : super(key: key);

  @override
  _DocumentTileState createState() => _DocumentTileState();
}

class _DocumentTileState extends State<DocumentTile> {
  late Color textColor;
  late Color backgroundColor;
  void click() {
    if (widget.onTap() != null) {
      widget.onTap();
    }
    switchColors();
  }

  void switchColors() {
    //also need to add to list of those being posted
    setState(() {
      Color temp = this.textColor;
      this.textColor = backgroundColor;
      this.backgroundColor = temp;
    });
  }

  @override
  void initState() {
    textColor = widget.textColor;
    backgroundColor = widget.backgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      onTap: click,
      title: Text(widget.text, style: TextStyle(color: this.textColor)),
      tileColor: this.backgroundColor,
    ));
  }
}

Future<void> showStoragePopup(BuildContext context, dynamic imageCallback) {
  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: true,
    isOverlayTapDismiss: true,
    descStyle: TextStyle(fontWeight: FontWeight.w400),
    descTextAlign: TextAlign.center,
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.black,
    ),
    alertAlignment: Alignment.center,
  );
  return Alert(
    context: context,
    style: alertStyle,
    title: "Image Upload",
    desc:
        "if you want an image to appear with the article, upload the image from this device's storage or enter a URL.",
    buttons: [
      DialogButton(
        color: Colors.blue,
        child: Text(
          "LOCAL",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () async {
          //choose from local storage (only valid if image)
          FilePickerResult? result =
              await FilePicker.platform.pickFiles(type: FileType.image);
          if (result != null) {
            List<File> files = result.paths.map((path) => File(path!)).toList();
            imageCallback(result.paths[0], isLocal: true);
            Navigator.pop(context);
          } else {
            // User canceled the picker
          }
        },
        radius: BorderRadius.circular(0.0),
      ),
      DialogButton(
        color: Colors.blue,
        child: Text(
          "URL",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          //snackbar for url
          Navigator.pop(context);
          showInput(context, "https://theimageurl.png", imageCallback);
        },
        radius: BorderRadius.circular(0.0),
      ),
    ],
  ).show();
}

void showInput(BuildContext context, String hintText, imageCallback) {
  TextEditingController _urlController = TextEditingController();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    margin: EdgeInsets.only(
        bottom: 0,
        left: MediaQuery.of(context).size.width / 16,
        right: MediaQuery.of(context).size.width / 16),
    behavior: SnackBarBehavior.floating,
    padding: EdgeInsets.zero,
    backgroundColor: Colors.white,
    content: Container(
      height: 50,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 5,
            color: Colors.grey,
          ),
          Container(
            width: 15,
          ),
          Expanded(
              child: TextFormField(
                  controller: _urlController,
                  decoration: InputDecoration(hintText: hintText))),
          IconButton(
              onPressed: () {
                imageCallback(_urlController.text, isLocal: false);
                ScaffoldMessenger.of(context).clearSnackBars();
              },
              icon: Icon(Icons.check),
              color: Colors.black)
        ],
      ),
    ),
    duration: Duration(seconds: 120),
  ));
}

void showError(BuildContext context, String text, {int milliseconds = 1500}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    margin: EdgeInsets.only(
        bottom: 10,
        left: MediaQuery.of(context).size.width / 16,
        right: MediaQuery.of(context).size.width / 16),
    behavior: SnackBarBehavior.floating,
    padding: EdgeInsets.zero,
    backgroundColor: Colors.white,
    content: Container(
      height: 50,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 5,
            color: Colors.red,
          ),
          Container(
            width: 15,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    ),
    duration: Duration(milliseconds: milliseconds),
  ));
}

void showSuccess(BuildContext context, String text, {int milliseconds = 1500}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    margin: EdgeInsets.only(
        bottom: 10,
        left: MediaQuery.of(context).size.width / 16,
        right: MediaQuery.of(context).size.width / 16),
    behavior: SnackBarBehavior.floating,
    padding: EdgeInsets.zero,
    backgroundColor: Colors.white,
    content: Container(
      height: 50,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 5,
            color: Colors.green,
          ),
          Container(
            width: 15,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    ),
    duration: Duration(milliseconds: milliseconds),
  ));
}

signOutUserWidget(BuildContext ctx) {
  return showModalBottomSheet<void>(
    backgroundColor: Colors.black,
    isScrollControlled: true,
    context: ctx,
    builder: (BuildContext context) {
      return Container(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Are you sure you want to sign out?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                decoration: TextDecoration.none,
              ),
            ),
            Container(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * .3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: kElevationToShadow[3],
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        "No",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    logout().then((success) {
                      if (success) {
                        while (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        }
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Choice()),
                        );
                      } else {
                        Navigator.of(context).pop();
                        showError(context, "Sign out was unsuccessful.");
                      }
                    });
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * .3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: kElevationToShadow[3],
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

class YesNoButton extends StatefulWidget {
  dynamic articleSettingsCallback;
  dynamic labelText;
  YesNoButton(
      {Key? key, @required this.labelText, this.articleSettingsCallback})
      : super(key: key);

  @override
  _YesNoButtonState createState() => _YesNoButtonState();
}

class _YesNoButtonState extends State<YesNoButton> {
  String display = "NO";
  void switchDisplay() {
    setState(() {
      display = display == "NO" ? "YES" : "NO";
    });
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.labelText),
        SizedBox(height: MediaQuery.of(context).size.height / 55),
        Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height / 35),
            child: Row(children: [
              GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: display == "YES" ? Colors.white : Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(display,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: display == "YES"
                                  ? Colors.black
                                  : Colors.white)),
                    ),
                  ),
                  onTap: () {
                    switchDisplay();
                    if (widget.articleSettingsCallback != null) {
                      widget.articleSettingsCallback(display);
                    }
                  })
            ])),
      ],
    );
  }
}

class GenreDropdown extends StatefulWidget {
  dynamic selectionCallback;
  String? chosenValue;
  GenreDropdown({@required this.selectionCallback, this.chosenValue});

  @override
  State<GenreDropdown> createState() => _GenreDropdownState();
}

class _GenreDropdownState extends State<GenreDropdown> {
  String? _hintValue;
  @override
  void initState() {
    setState(() {
      _hintValue = widget.chosenValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Genre"),
        SizedBox(height: MediaQuery.of(context).size.height / 200),
        Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 35),
          child: Container(
            padding: const EdgeInsets.all(0.0),
            child: DropdownButton<DropdownTitle>(
              //elevation: 5,
              style: TextStyle(color: Colors.black),

              items: <DropdownTitle>[
                DropdownTitle('Books and Film', 0),
                DropdownTitle("Politics", 1),
                DropdownTitle('Creative Writing and Satire', 2),
                DropdownTitle('Sports', 3),
                DropdownTitle('Food', 4),
                DropdownTitle('Actual News', 5),
                DropdownTitle('Opinion', 6)
              ].map<DropdownMenuItem<DropdownTitle>>((DropdownTitle val) {
                return DropdownMenuItem<DropdownTitle>(
                  value: val,
                  child: Text(val.getTitle()),
                );
              }).toList(),
              hint: Text(
                _hintValue == null ? "Please choose a genre" : _hintValue!,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              onChanged: (value) {
                widget.selectionCallback(value!.getTitle());
                setState(() {
                  _hintValue = value.getTitle();
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
