import 'package:dejla/router/Routers.dart';
import 'package:dejla/services/Profile.dart';
import 'package:dejla/services/Search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dejla/services/Auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          value: authService.user,
        ),
        ChangeNotifierProvider<SearchService>.value(
          // Provider<SearchService>.value(
          value: searchService,
        ),
        // User profile
        ChangeNotifierProvider<ProfileService>.value(
          value: profileService,
        ),
        Provider<AuthService>.value(
          value: authService,
        ),
      ],
      child: Builder(
        builder: (BuildContext context) {
          return MaterialApp(
            title: 'Dejla',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.blue,
            ),
            // home: MyHomePage(title: 'Flutter Demo Home Page'),
            onGenerateRoute: onGenerateRoute,
            initialRoute: '/',
          );
        },
      ),
    );
  }
}
