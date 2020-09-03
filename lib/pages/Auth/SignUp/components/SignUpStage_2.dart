import 'package:dejla/modules/PhoneNumber.dart';
import 'package:dejla/services/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:quiver/async.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:provider/provider.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class SignUpStage2 extends StatefulWidget {
  SignUpStage2({Key key}) : super(key: key);

  @override
  _SignUpStage2State createState() => _SignUpStage2State();
}

class _SignUpStage2State extends State<SignUpStage2> {
  int _start = 60;
  int _count = 0;
  String code = '';

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _count = _start - duration.elapsed.inSeconds;
      });
    });

    sub.onDone(() {
      print("Done");
      sub.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    PhoneNumber phoneNumber = Provider.of<PhoneNumber>(context);
    AuthService auth = Provider.of<AuthService>(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height - 30,
                width: MediaQuery.of(context).size.width,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Spacer(),
                      Flexible(
                          child: Text(
                        "Verify your number",
                        style: textTheme.headline,
                      )),
                      Flexible(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "A 6-digit code has beed sent to",
                              style: textTheme.body1,
                            ),
                            Text(
                              "${phoneNumber.internationalizedPhoneNumber}",
                              style: textTheme.body2,
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: PinInputTextField(
                            autoFocus: true,
                            pinLength: 6,
                            onChanged: (data) {
                              setState(() {
                                code = data;
                              });
                            },
                          ),
                        ),
                      ),
                      Text(
                        "Did not get verification code?",
                        style: textTheme.body2,
                      ),
                      Builder(
                        builder: (BuildContext context) {
                          if (_count != 0)
                            return Text("Try later in $_count seconds");
                          else
                            return InkWell(
                              child: Text(
                                "Send code again",
                                style: TextStyle(color: GFColors.PRIMARY),
                              ),
                              onTap: () {
                                _count = 0;
                                startTimer();
                                auth.phoneNumberVerify(
                                    phoneNumber.internationalizedPhoneNumber);
                              },
                            );
                        },
                      ),
                      GFButton(
                        size: GFSize.LARGE,
                        text: "Verify",
                        onPressed: code.length != 6
                            ? null
                            : () {
                                var result = auth.phoneNumberSignIn(code);
                                if (auth.user != null) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/wrapper',
                                      (Route<dynamic> route) => false);
                                }
                                print(result.runtimeType);
                              },
                      ),
                      Spacer(
                        flex: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            child: IconButton(
              icon: Icon(
                FontAwesome.angle_left,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
