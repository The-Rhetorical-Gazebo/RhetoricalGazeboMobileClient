import 'package:flutter/material.dart';
import "Login.dart";
import "../../pages/Home.dart";
import "Register.dart";
import "../pages/Home.dart";
import "../utilities/localStorage.dart" as localStorage;
//TODO: Have loading screen instead of going here to check local storage first

class Choice extends StatefulWidget {
  const Choice({Key? key}) : super(key: key);

  @override
  State<Choice> createState() => _ChoiceState();
}

class _ChoiceState extends State<Choice> {
  Future<bool> checkRememberMe() async {
    try {
      var remembered = await localStorage.readFromLocalStorage("remember");
      return remembered;
    } catch (err) {
      print("Field not present: $err");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
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
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.black, Colors.grey],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Write",
                          style: TextStyle(color: Colors.white, fontSize: 24),
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
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        border: Border.all(
                          width: 3,
                          color: Colors.black,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Read",
                          style: TextStyle(color: Colors.black, fontSize: 24),
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
  }
}
