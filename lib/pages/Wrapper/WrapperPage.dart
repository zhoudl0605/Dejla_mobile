import 'package:dejla/pages/App/App.dart';
import 'package:dejla/pages/Auth/AuthPage.dart';
import 'package:dejla/pages/Auth/InitialAccount/InitialProfile.dart';
import 'package:dejla/services/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class WrapperPage extends StatefulWidget {
  WrapperPage({Key key}) : super(key: key);

  @override
  _WrapperPageState createState() => _WrapperPageState();
}

class _WrapperPageState extends State<WrapperPage> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

    return StreamBuilder(
        stream: auth.user,
        // future: auth.getCurrentUser(),
        builder: (context, snapshot) {
          FirebaseUser user = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Container(
                child: SpinKitCircle(
                  color: Colors.green,
                ),
              ),
            );
          }

          if (user == null) {
            return AuthPage();
          } else {
            if (user.email == null || user.email == "") {
              return InitialAccountPage();
            } else {
              return APP();
            }
          }
        });
  }
}
