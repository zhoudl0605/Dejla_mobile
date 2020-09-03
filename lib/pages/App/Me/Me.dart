import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:dejla/services/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:getflutter/getflutter.dart';
import 'package:provider/provider.dart';

class Me extends StatefulWidget {
  Me({Key key}) : super(key: key);

  @override
  _MeState createState() => _MeState();
}

class _MeState extends State<Me> {
  String url;

  @override
  Widget build(BuildContext context) {
    Widget authButton = RaisedButton(
      child: Text("TO LOGIN"),
      onPressed: () => Navigator.of(context).pushNamed("/login"),
    );

    if (Provider.of<FirebaseUser>(context) != null) {
      url = Provider.of<FirebaseUser>(context).photoUrl;
      authButton = RaisedButton(
        child: Text("Sign Out"),
        onPressed: () {
          authService.signOut();
        },
      );
    }

    AuthService auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        // set the height of appbar
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
                stream: auth.user,
                builder: (context, snapshot) {
                  FirebaseUser user = snapshot.data;
                  return CircularProfileAvatar(
                    user != null ? user.photoUrl : "",
                    radius: 18,
                    elevation: 0,
                    backgroundColor: Colors.white,
                    onTap: () {},
                    cacheImage: true,
                    errorWidget: (context, url, error) => Container(
                      child: Icon(
                        AntDesign.user,
                        color: Colors.grey,
                        size: 25,
                      ),
                    ),
                    placeHolder: (context, url) => Container(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }),

            Expanded(child: Container()),
            // Replace the child of paddGlobalKeying for different page
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Me",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
        // Disable and hide the leading button
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SafeArea(
          child: ListView(
        children: <Widget>[
          StreamBuilder(
            stream: auth.user,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data != null)
                return Container(
                  child: Column(
                    children: <Widget>[
                      Text("${snapshot.data.uid}"),
                      Text("${snapshot.data.email}"),
                    ],
                  ),
                );
              else
                return Container();
            },
          ),
          authButton,
          GFButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/newprofile");
            },
            text: "new profile",
          )
        ],
      )),
    );
  }
}
