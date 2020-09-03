import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailDescription extends StatefulWidget {
  DetailDescription({Key key}) : super(key: key);

  @override
  _DetailDescriptionState createState() => _DetailDescriptionState();
}

class _DetailDescriptionState extends State<DetailDescription> {
  bool descriptionFoldFlag = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Consumer<DocumentSnapshot>(
      builder: (BuildContext context, DocumentSnapshot value, Widget child) {
        return Card(
          elevation: 5,
          child: ListTile(
            title: Text(
              "Description",
              style: textTheme.headline6,
            ),
            subtitle: Container(
              child: Column(
                children: <Widget>[
                  Text(
                    "${value.data['description']}",
                    style: textTheme.bodyText2,
                    maxLines: descriptionFoldFlag == true ? 10 : null,
                    softWrap: true,
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        descriptionFoldFlag = !descriptionFoldFlag;
                      });
                    },
                    child: Text(descriptionFoldFlag == true
                        ? "Read more"
                        : "Read less"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
