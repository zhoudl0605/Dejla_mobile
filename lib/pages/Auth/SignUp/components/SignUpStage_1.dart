import 'package:dejla/modules/PhoneNumber.dart';
import 'package:dejla/modules/SequentialStage.dart';
import 'package:dejla/services/Auth.dart';
import 'package:flutter/gestures.dart';
import 'package:getflutter/getflutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:international_phone_input/international_phone_input.dart';

class SignUpStage1 extends StatefulWidget {
  SignUpStage1({Key key}) : super(key: key);

  @override
  _SignUpStage1State createState() => _SignUpStage1State();
}

class _SignUpStage1State extends State<SignUpStage1> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    SequentialStage stage = Provider.of<SequentialStage>(context);
    PhoneNumber phoneNumber = Provider.of<PhoneNumber>(context);
    AuthService auth = Provider.of<AuthService>(context);

    void onPhoneNumberChange(
        String number, String internationalizedPhoneNumber, String isoCode) {
      setState(() {
        phoneNumber.number = number;
        phoneNumber.isoCode = isoCode;
        phoneNumber.internationalizedPhoneNumber = internationalizedPhoneNumber;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                  child: Text(
                    "Set up your account with phone number",
                    style: textTheme.headline,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      InternationalPhoneInput(
                        onPhoneNumberChange: onPhoneNumberChange,
                        initialPhoneNumber: phoneNumber.number,
                        initialSelection: phoneNumber.isoCode,
                        enabledCountries: ['+1', "+86"],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 30,
                        ),
                        child: Center(
                          child: Text(
                            "Dejla will send you an SMS message for " +
                                "authentication to your phone number, " +
                                "carrier rates may apply.",
                            style: textTheme.caption,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: GFButton(
                          onPressed: phoneNumber.number == null ||
                                  phoneNumber.number == ""
                              ? null
                              : () async {
                                  await auth.phoneNumberVerify(
                                      phoneNumber.internationalizedPhoneNumber);
                                  // Navigator.of(context).pushNamed('/signup');

                                  if (auth.user == null)
                                    setState(() {
                                      stage.increase();
                                    });
                                  else
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/',
                                            (Route<dynamic> route) => false);
                                },
                          text: "Send",
                          size: GFSize.LARGE,
                          // color: GFColors.INFO,
                          fullWidthButton: true,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "Having problems? ",
                          style: textTheme.caption,
                        ),
                        new TextSpan(
                          text: 'Contact with us',
                          style: new TextStyle(color: Colors.blue),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              //TODO: change the hyperlink to Dejla
                              launch('https://hyperoptimal.ca');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
