import 'package:dejla/pages/Auth/Login/Components/LoginForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:getflutter/getflutter.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image(
                          image: AssetImage("assets/dejla_logo.png"),
                          height: textTheme.display3.fontSize,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Life can be easier",
                          style: textTheme.body2,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  // constraints: BoxConstraints(maxHeight: 300, minHeight: 240.0),
                  child: LoginForm(),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don't have an account with us? ",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed('/signup');
                          },
                        ),
                      ],
                    ),
                    Text(
                      "or",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "Browse list",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/app', ModalRoute.withName('/'));
                      },
                    ),
                    // TODO: third party login
                    // Text(
                    //   "Or",
                    //   style: TextStyle(
                    //     color: Colors.grey,
                    //   ),
                    // ),
                    // SignInButton(
                    //   Buttons.Facebook,
                    //   mini: true,
                    //   onPressed: () {},
                    // ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
