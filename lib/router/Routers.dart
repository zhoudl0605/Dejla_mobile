import 'package:dejla/pages/App/Explore/Detail/Detail.dart';
import 'package:dejla/pages/Apply/Apply.dart';
// import 'package:dejla/pages/App/Explore/MapView/MapView.dart';
// import 'package:dejla/pages/App/Explore/Search.dart';
import 'package:dejla/pages/Auth/AuthPage.dart';
import 'package:dejla/pages/Search/SearchAddress.dart';
import 'package:dejla/pages/Auth/Login/Login.dart';
import 'package:dejla/pages/Auth/ResetPwd/ResetPwd.dart';
import 'package:dejla/pages/Auth/SignUp/SignUp.dart';
import 'package:dejla/pages/Wrapper/WrapperPage.dart';
import 'package:flutter/material.dart';
import 'package:dejla/pages/App/App.dart';
import 'package:dejla/pages/App/Profile/NewProfile/NewProfile.dart';
import 'package:dejla/pages/App/Explore/Building/BuildingUnitsPage.dart';

// import '../pages/Search.dart'; //example import the page

final routes = {
  // '/':(context)=>Tabs(), //example set the main page
  '/': (context) => WrapperPage(),
  '/auth': (context) => AuthPage(),
  '/login': (context) => LoginPage(),
  '/signup': (context) => SignUpPage(),
  '/resetpwd': (context) => ResetPwdPage(),
  '/app': (context) => APP(),
  '/newprofile': (context) => NewProfilePage(),
  '/searchaddress': (context, {arguments}) =>
      SearchAddressPage(arguments: arguments),
  // '/search': (context) => SearchPage(),
  '/detail': (context, {arguments}) => DetailPage(arguments: arguments),
  // '/mapview': (context, {arguments}) => MapViewPage(arguments: arguments),
  '/buildingUnits': (context, {arguments}) =>
      BuildingUnitsPage(arguments: arguments),
  '/apply': (context, {arguments}) => ApplyPage(arguments: arguments),
  // '/form':(context)=>FormPage(), //example for normal page
  // '/login': (context) => AuthPage(),
  // '/addProfile': (context) => AddProfilePage(),
  // '/search':(context,{arguments})=>SearchPage(arguments:arguments), // example for page with sending argument
};

// for handle all the routes together
// fixed function do not change
var onGenerateRoute = (RouteSettings settings) {
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
