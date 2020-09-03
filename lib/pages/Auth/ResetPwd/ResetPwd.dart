import 'package:flutter/material.dart';

class ResetPwdPage extends StatefulWidget {
  ResetPwdPage({Key key}) : super(key: key);

  @override
  _ResetPwdPageState createState() => _ResetPwdPageState();
}

class _ResetPwdPageState extends State<ResetPwdPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text("Reset Password"),
      ),
    );
  }
}
