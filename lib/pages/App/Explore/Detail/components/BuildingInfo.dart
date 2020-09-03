import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class BuildingInfo extends StatelessWidget {
  const BuildingInfo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentSnapshot>(
      builder: (BuildContext context, DocumentSnapshot value, Widget child) {
        if (value.data['building'] == null) return Container();
        return InkWell(
          child: Card(
            elevation: 5,
            child: ListTile(
              leading: CircleAvatar(
                radius: 20.0,
                backgroundImage:
                    NetworkImage("${value.data['building']['icon']}"),
                backgroundColor: Colors.transparent,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("${value.data['building']['name']}"),
                  Icon(FontAwesome.angle_right),
                ],
              ),
            ),
          ),
          onTap: () {},
        );
      },
    );
  }
}
