import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import "Login.dart";
import "../../pages/Home.dart";
import "package:flutter/cupertino.dart";
import "Register.dart";
import "../pages/Home.dart";
import "package:http/http.dart" as http;
import "../utilities/localStorage.dart" as localStorage;
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:pull_to_refresh/pull_to_refresh.dart";
//TODO: Have loading screen instead of going here to check local storage first

class Choice extends StatefulWidget {
  const Choice({Key? key}) : super(key: key);

  @override
  State<Choice> createState() => _ChoiceState();
}

class _ChoiceState extends State<Choice> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    init().then((args) {
      setState(() {
        _loading = false;
        _refreshController.refreshCompleted();
      });
    });
    // if failed,use refreshFailed()
  }

  bool _loading = true;
  bool _serverRunning = false;
  Future<bool> checkRememberMe() async {
    try {
      var remembered = await localStorage.readFromLocalStorage("remember");
      return remembered;
    } catch (err) {
      print("Field not present: $err");
      return false;
    }
  }

  Future<void> init() async {
    // Check if server is running
    try {
      var response = await http.get(Uri.parse("${dotenv.env["domain"]!}"));
      if (response.statusCode == 502) {
        throw ErrorDescription("Cloud server is currently down.");
      }
      setState(() {
        _serverRunning = true;
      });
    } catch (err) {
      setState(() {
        _serverRunning = false;
      });
    }
  }

  @override
  void initState() {
    init().then((_) {
      setState(() {
        _loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    if (_loading) {
      return Scaffold(
        body: Center(
          child: SpinKitWave(
            color: Colors.black,
            size: 50.0,
          ),
        ),
      );
    } else {
      if (_serverRunning) {
        return Padding(
          padding: EdgeInsets.only(
            top: statusBarHeight,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                //["cyan", "red", "green", "darkblue", "yellow"]
                colors: [
                  Colors.white,
                  Colors.white,
                  Colors.white,
                  Colors.white70
                ],
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/GazeboSplash.png"),
                      SizedBox(height: 60),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          checkRememberMe().then((remembered) {
                            if (remembered) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EmployeeHome(),
                                  ));
                            }
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .8,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Colors.black, Colors.grey],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Write",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 25,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .8,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            border: Border.all(
                              width: 3,
                              color: Colors.black,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Read",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.black,
            title:
                Image.asset("assets/logo.png", scale: 10, color: Colors.white),
          ),
          body: SmartRefresher(
            enablePullDown: true,
            header: WaterDropHeader(
                complete: Icon(Icons.check, color: Colors.green)),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: () {},
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Don't Panic!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 35),
                            textAlign: TextAlign.center),
                        SizedBox(height: 10),
                        Text(
                            "The Rhetorical Gazebo is currently offline, but our servers will be back up soon!",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w300)),
                        Text(
                            "Please try again later and get back to reading and writing the finest content on the web.",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w300)),
                        SizedBox(height: 20),
                        Text("Pull down to refresh the page!",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w300)),
                        Icon(Icons.arrow_downward_sharp, color: Colors.black),
                      ]),
                )
              ],
            ),
          ),
        );
      }
    }
  }
}
