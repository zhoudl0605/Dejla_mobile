import 'package:dejla/modules/PhoneNumber.dart';
import 'package:dejla/modules/SequentialStage.dart';
import 'package:dejla/pages/Auth/AuthPage.dart';
import 'package:dejla/pages/Auth/SignUp/components/SignUpStage_1.dart';
import 'package:dejla/pages/Auth/SignUp/components/SignUpStage_2.dart';
import 'package:dejla/services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  PhoneNumber phoneNumber = new PhoneNumber();

  List<Widget> stages = [
    SignUpStage1(),
    SignUpStage2(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SequentialStage>(
          create: (_) => SequentialStage(),
        ),
        Provider<PhoneNumber>.value(value: phoneNumber),
      ],
      child: Builder(
        builder: (context) {
          SequentialStage stage = Provider.of<SequentialStage>(context);
          return stages[stage.stage];
        },
      ),
    );
  }
}
