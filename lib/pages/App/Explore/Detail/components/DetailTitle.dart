import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dejla/widget/Favorite_Widget.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';

class DetailTitle extends StatelessWidget {
  const DetailTitle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Consumer<DocumentSnapshot>(
      builder: (BuildContext context, DocumentSnapshot value, Widget child) {
        return Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: Text(
                  value.data["title"].toString(),
                  style: textTheme.headline5,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            ListTile(
              title: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "\$",
                        style: textTheme.subtitle1,
                      ),
                      Text(
                        "${value.data['price']['amount']}",
                        style: textTheme.headline5,
                      ),
                    ],
                  ),
                ],
              ),
              trailing: FavoriteWidget(
                path: value.reference.path,
              ),
              subtitle: InkWell(
                child: RichText(
                  maxLines: 1,
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(Icons.location_on, size: 16),
                      ),
                      TextSpan(
                        text: "${value.data['address']['line_1']}," +
                            " ${value.data['address']['city']}," +
                            " ${value.data['address']['province']}," +
                            " ${value.data['address']['postal_code']}",
                        style: textTheme.caption,
                      )
                    ],
                  ),
                ),
                onTap: () {
                  var address = "${value.data['address']['line_1']}," +
                      " ${value.data['address']['city']}," +
                      " ${value.data['address']['province']}," +
                      " ${value.data['address']['postal_code']}";
                  MapsLauncher.launchQuery('$address');
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
