import 'package:dejla/services/Auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:getflutter/colors/gf_color.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/getflutter.dart';
import 'package:getflutter/size/gf_size.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InitialAccountPage extends StatefulWidget {
  InitialAccountPage({Key key}) : super(key: key);

  @override
  _InitialAccountPageState createState() => _InitialAccountPageState();
}

class _InitialAccountPageState extends State<InitialAccountPage> {
  FocusNode nodeOne = FocusNode();
  FocusNode nodeTwo = FocusNode();
  final _formKey = GlobalKey<FormState>();

  String email;
  String passWord;

  @override
  void dispose() {
    nodeOne.dispose();
    nodeTwo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    AuthService auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Complete your account",
          style: textTheme.title,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          child: Icon(
            FontAwesome.angle_left,
            color: Colors.black,
          ),
          onTap: () async {
            await auth.signOut();
          },
        ),
      ),
      body: Builder(builder: (context) {
        return SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email",
                      ),
                      autofocus: true,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).requestFocus(nodeOne);
                      },
                      maxLines: 1,
                      validator: (value) {
                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(value))
                          return 'Enter Valid Email';
                        else
                          return null;
                      },
                      onChanged: (String val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",
                      ),
                      obscureText: true,
                      focusNode: nodeOne,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).requestFocus(nodeTwo);
                      },
                      maxLines: 1,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter password';
                        }
                        if (value.length < 8) {
                          return 'Passwords must more than 8 characters';
                        }
                        return null;
                      },
                      onChanged: (String val) {
                        setState(() {
                          passWord = val;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Confirm password",
                      ),
                      obscureText: true,
                      focusNode: nodeTwo,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter password';
                        }
                        if (value != passWord) {
                          return 'Two password are not same';
                        }
                        return null;
                      },
                      maxLines: 1,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: textTheme.caption,
                  children: [
                    TextSpan(
                        text: "By click the submit button you agree with "),
                    TextSpan(
                      text: "the term of use",
                      style: TextStyle(color: GFColors.PRIMARY),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          launch('https://dejla.ca/term_of_use');
                        },
                    ),
                  ],
                ),
              ),
              GFButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    // If the form is valid
                    var emailResult = await auth.setUserEmail(email);
                    var passResult = await auth.setUserPassword(passWord);

                    // Update the user profile and check error
                    if (emailResult != null) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("${emailResult.message}")));
                      return;
                    }
                    if (passResult != null) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("${passResult.message}")));
                      return;
                    }
                    await auth.reloadFirebaseUser();

                    // If update success
                    Navigator.of(context).pushNamed('/newprofile');
                  }
                },
                text: "Submit",
                size: GFSize.LARGE,
              ),
            ],
          ),
        );
      }),
    );
  }
}
