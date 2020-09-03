import 'package:flutter/material.dart';

class ApplyPage extends StatefulWidget {
  final Map arguments;

  ApplyPage({Key key, this.arguments}) : super(key: key);

  @override
  _ApplyPageState createState() => _ApplyPageState(arguments: this.arguments);
}

class _ApplyPageState extends State<ApplyPage> {
  final Map arguments;
  _ApplyPageState({this.arguments});
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Text('This is apply page'),
        ],
      ),
    );
  }
}
