import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import "../utilities/login_ui.dart";
import "package:http/http.dart" as http;
import "../utilities/localStorage.dart" as localStorage;
import "package:flutter_dotenv/flutter_dotenv.dart";
import "dart:convert";
import "../pages/Home.dart";
import "../utilities/widgets.dart";
import "login.dart";
import "../utilities/utils.dart";
import "package:email_validator/email_validator.dart";
import 'package:url_launcher/url_launcher.dart';

String tokenPopupMessage =
    "Referall tokens inhibit an excess of writers and written content at a given time. Before your registration, you should have spoken to someone from The Rhetorical Gazebo from whom you would have received a token. You can then this token in the indicated field to register as a writer with The Rhetorical Gazebo. If your token is invalid or you wish to register as a writer, please reach out to following email.";
TextStyle emailTextStyleNoUnderline = TextStyle(
    color: Colors.lightBlue, fontWeight: FontWeight.w800, fontSize: 16);
TextStyle emailTextStyleUnderline = TextStyle(
    color: Colors.lightBlue,
    fontWeight: FontWeight.w800,
    fontSize: 16,
    decoration: TextDecoration.underline);

void _launchURL(String url) async {
  if (!await launch(url)) throw 'Could not launch $url';
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _rememberMe = false;
  TextStyle questionTextStyle = kLabelStyleMin;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _password2Controller = TextEditingController();
  TextEditingController _tokenController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

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
  initState() {
    checkRememberMe().then((rememberMe) {
      if (rememberMe) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EmployeeHome()),
        );
      }
    });
    super.initState();
  }

  Future<void> register() async {
    try {
      var url = Uri.parse(dotenv.env["domain"]! + "/api/users/writer");
      //capitalize name function
      if (_nameController.text == "") {
        showError(context, "Please enter your name.");
        return;
      }
      if (!isFirstLast(_nameController.text)) {
        showError(
            context, "Name must have format (First Last) or (Last, First).");
        return;
      }
      if (_emailController.text == "") {
        showError(context, "Please enter an email");
        return;
      }
      if (!EmailValidator.validate(_emailController.text)) {
        showError(context, "Please enter a valid email.");
        return;
      }
      if (_passwordController.text == "") {
        showError(context, "Please enter a password.");
        return;
      }
      if (_password2Controller.text == "") {
        showError(context, "Please confirm your password.");
        return;
      }
      if (_tokenController.text == "") {
        showError(context,
            'Please enter a referral token. If you need help, please click "What is this?"');
        return;
      }
      if (_passwordController.text != _password2Controller.text) {
        //show error
        showError(context, "Passwords do not match.");
        return;
      }
      String nameEntry = capitalizeAndFormat(_nameController.text);
      var body = {
        "name": _nameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "token": _tokenController.text
      };
      var responseUtil = await http.post(url,
          body: json.encode(body),
          headers: {"Content-Type": "application/json"});
      Map<String, dynamic> response = json.decode(responseUtil.body);
      if (response.containsKey("error")) {
        print(response["error"]["msg"]);
        showError(context, response["error"]["msg"]);
        throw ErrorDescription(json.encode(response["error"]));
      }
      //login success
      await localStorage.writeToLocalStorage("x-auth-token", response["token"]);
      if (_rememberMe) {
        await localStorage.writeToLocalStorage("remember", true);
      }
      ;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EmployeeHome()),
      );
    } catch (err) {
      print("Error registering: $err");
    }
  }

  Widget _buildTF(String labelText, String hintText, IconData prefixIcon,
      TextEditingController new_controller, bool isPasswordField) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          labelText,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 52.5,
          child: TextFormField(
            controller: new_controller,
            obscureText: isPasswordField,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                prefixIcon,
                color: Colors.black,
              ),
              hintText: hintText,
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTokenTF(String labelText, String hintText, Function callback,
      {String extraLabel = ""}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: [
          Text(
            labelText,
            style: kLabelStyle,
          ),
          SizedBox(width: 7.5),
          GestureDetector(
              onTapDown: (details) {
                setState(() {
                  questionTextStyle = kLabelStyleMax;
                });
                if (callback != null) {
                  callback([]);
                }
              },
              onTapUp: (details) {
                setState(() {
                  questionTextStyle = kLabelStyleMin;
                });
              },
              child: Text(extraLabel, style: questionTextStyle)),
        ]),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 52.5,
          child: TextFormField(
            controller: _tokenController,
            obscureText: false,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.vpn_key,
                color: Colors.black,
              ),
              hintText: hintText,
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value!;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => register(),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'SIGN UP',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: () {
        print("Social button pressed.");
      },
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => print('Register with Facebook'),
            AssetImage(
              'assets/logos/facebook.jpg',
            ),
          ),
          _buildSocialBtn(
            () => print('Register with Google'),
            AssetImage(
              'assets/logos/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Already have an account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 25.0,
              ),
              Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontSize: 29.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildTF("Name", "Enter your Name (Last, First)", Icons.person,
                  _nameController, false),
              SizedBox(height: 25.0),
              _buildTF("Email", "Enter your Email", Icons.email,
                  _emailController, false),
              SizedBox(
                height: 25.0,
              ),
              _buildTF("Password", "Enter your Password", Icons.lock,
                  _passwordController, true),
              SizedBox(
                height: 25.0,
              ),
              _buildTF("Confirm Password", "Confirm your Password", Icons.lock,
                  _password2Controller, true),
              SizedBox(
                height: 25.0,
              ),
              _buildTokenTF("Referral Token", "Your Referral Token", (args) {
                showPopup(
                    context,
                    "Referral Tokens",
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(tokenPopupMessage,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    height: 1.25)),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 50),
                        LinkedText(
                            centerText: true,
                            text: "therhetoricalgazebo@gmail.com",
                            up: emailTextStyleNoUnderline,
                            down: emailTextStyleUnderline,
                            callback: (args) async {
                              Navigator.pop(context);
                              setState(() {
                                questionTextStyle = kLabelStyleMin;
                              });
                              if (!await launch(args[0])) {
                                throw 'Could not launch ${args[0]}';
                              }
                            },
                            callbackArgs: [
                              "mailto:therhetoricalgazebo@gmail.com"
                            ])
                      ],
                    ), () {
                  Navigator.pop(context);
                  setState(() {
                    questionTextStyle = kLabelStyleMin;
                  });
                }, buttons: [DialogButton(child: Text("EXIT", style: TextStyle(color: Colors.white,
                       fontWeight: FontWeight.w600, fontSize: 18)), onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    questionTextStyle = kLabelStyleMin;
                  });
                })]);
              }, extraLabel: "What is this?"),
              SizedBox(
                height: 25.0,
              ),
              _buildRememberMeCheckbox(),
              _buildRegisterBtn(),
              _buildSignInBtn(),
            ],
          ),
        ),
      ),
    );
  }
}
