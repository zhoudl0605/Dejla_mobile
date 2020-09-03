import 'package:dejla/services/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:getflutter/getflutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final focusPassword = FocusNode();
  String _email = "";
  String _pwd = "";
  Color _buttonColor = Color(0xff0f4c81);

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusPassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (val) {
                FocusScope.of(context).requestFocus(focusPassword);
              },
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
                  _email = val;
                });
              },
            ),
            TextFormField(
              focusNode: focusPassword,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              keyboardType: TextInputType.visiblePassword,
              onChanged: (String val) {
                setState(() {
                  _pwd = val;
                });
              },
              validator: (value) {
                if (value.isEmpty)
                  return 'Enter Password';
                else
                  return null;
              },
            ),
            Align(
              alignment: Alignment.topRight,
              child: FlatButton(
                child: Text(
                  "Forget Password",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onPressed: () {
                  if (_email.isNotEmpty) {
                    authService.resetPassword(_email);
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "We send an email to your email address for resetting your password"),
                      ),
                    );
                  } else {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Please enter your password in the email field"),
                      ),
                    );
                  }
                },
              ),
            ),
            GFButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  // If all data are correct then save data to out variables
                  _formKey.currentState.save();
                  print("$_email, $_pwd");
                  var res = await authService.emailSignIn(_email, _pwd);
                  switch (res.runtimeType) {
                    case FirebaseUser:
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (Route<dynamic> route) => false);
                      break;
                    default:
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(res.message),
                        ),
                      );
                  }
                }
              },
              text: "Sign in",
              size: GFSize.LARGE,
              type: GFButtonType.solid,
            ),
          ],
        ),
      ),
    );
  }
}
