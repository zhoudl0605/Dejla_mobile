import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dejla/pages/App/Explore/Detail/components/AppBar.dart';
import 'package:dejla/pages/App/Explore/Detail/components/DetailDescription.dart';
import 'package:dejla/pages/App/Explore/Detail/components/DetailMap.dart';
import 'package:dejla/pages/App/Explore/Detail/components/DetailTitle.dart';
import 'package:dejla/pages/App/Explore/Detail/components/UpcomingUnit.dart';
import 'package:dejla/pages/App/Explore/Detail/components/UnitDetail.dart';
import 'package:dejla/services/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/getflutter.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DetailPage extends StatefulWidget {
  final Map arguments;

  DetailPage({Key key, this.arguments}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState(arguments: this.arguments);
}

class _DetailPageState extends State<DetailPage> {
  final Map arguments;
  _DetailPageState({this.arguments});
  bool showalert = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (arguments['documentID'] == null && arguments['data'] == null) {
      Navigator.of(context).pop();
      return Container();
    }

    // if only pass in unit id
    if (arguments['documentID'] != null && arguments['data'] == null) {
      Firestore.instance.document("${arguments['id']}").get().then((data) {
        arguments['data'] = data;
      });
    }

    List<Widget> images = [];
    DocumentSnapshot doc = arguments['document'];

    // Get unit images
    List imagesUrl = arguments['data']["images"];
    Map data = arguments['data'];
    imagesUrl.forEach((url) {
      images.add(
        Image(
          image: CachedNetworkImageProvider(url),
          fit: BoxFit.cover,
        ),
      );
    });

    return Provider<DocumentSnapshot>.value(
      value: doc,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              DeatilPageAppBar(
                images: images,
              ),
            ];
          },
          body: ListView(
            children: <Widget>[
              DetailTitle(),

              // TODO: complete the building info page first
              // BuildingInfo(),
              DetailMap(),
              // Description
              DetailDescription(),
              // Upcoming unit
              UpcomingUnit(),

              UnitDetailWidget(
                data: data,
              ),
            ],
          ),
        ),
        bottomNavigationBar: GFButton(
          padding: EdgeInsets.all(0),
          onPressed: () async {
            FirebaseUser _user =
                await Provider.of<AuthService>(context, listen: false)
                    .getCurrentUser();
            if (_user == null)
              Alert(
                style: AlertStyle(
                  descStyle: textTheme.bodyText2,
                  alertBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
                context: context,
                type: AlertType.info,
                title: "Dejla User Only",
                desc:
                    "Dear guest, seems like you are not login. Please login to unlock all features.",
                buttons: [
                  DialogButton(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: GFColors.WHITE,
                        fontStyle: textTheme.button.fontStyle,
                      ),
                    ),
                    radius: BorderRadius.zero,
                    onPressed: () => Navigator.pop(context),
                  ),
                  DialogButton(
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        color: GFColors.WHITE,
                        fontStyle: textTheme.button.fontStyle,
                      ),
                    ),
                    radius: BorderRadius.zero,
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ).show();
            else
              Navigator.of(context).pushNamed(
                '/apply',
                arguments: {
                  'document': doc,
                },
              );
          },
          size: GFSize.LARGE,
          shape: GFButtonShape.square,
          color: GFColors.PRIMARY,
          text: "Apply",
          // fullWidthButton: true,
        ),
      ),
    );
  }
}
