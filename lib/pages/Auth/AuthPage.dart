import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height - 30,
                  child: Column(
                    children: <Widget>[
                      Spacer(
                        flex: 2,
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: <Widget>[
                            // Logo and slogan
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image(
                                      image:
                                          AssetImage("assets/dejla_logo.png"),
                                      height: textTheme.display3.fontSize,
                                    ),
                                    Text(
                                      "Dejla",
                                      style: TextStyle(
                                        fontSize: textTheme.display2.fontSize,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Life can be easier",
                                  style: textTheme.body2,
                                ),
                              ],
                            ),
                            // Log in and create account
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                children: <Widget>[
                                  GFButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed('/signup');
                                    },
                                    text: "Create account",
                                    size: GFSize.LARGE,
                                    // color: GFColors.INFO,
                                    fullWidthButton: true,
                                  ),
                                  GFButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed('/login');
                                    },
                                    text: "Log in",
                                    size: GFSize.LARGE,
                                    fullWidthButton: true,
                                    type: GFButtonType.outline,
                                    color: GFColors.DARK,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Image(
                            image: AssetImage("assets/auth_page.png"),
                          )),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              child: GFButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/app');
                },
                text: "Skip",
                type: GFButtonType.transparent,
              ),
              right: 0,
            ),
          ],
        ),
      ),
    );
  }
}
