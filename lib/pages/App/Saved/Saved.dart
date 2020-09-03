import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dejla/modules/UserProfile.dart';
import 'package:dejla/services/Profile.dart';
import 'package:dejla/widget/Favorite_Widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedPage extends StatefulWidget {
  SavedPage({Key key}) : super(key: key);

  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    var _user = Provider.of<FirebaseUser>(context);
    var profile = Provider.of<ProfileService>(context);

    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Saved"),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: ListView(
          children: <Widget>[
            Text("You are not logged in"),
            RaisedButton(
              child: Text("TO LOGIN"),
              onPressed: () => Navigator.of(context).pushNamed("/login"),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Saved"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Builder(
          builder: (BuildContext context) {
            UserProfile _profile = profile.profile;
            if (_profile == null) {
              debugPrint("no profile");
              return Container(
                child: Text("Your favorite list is empty"),
              );
            } else if (_profile.favorite == null) {
              return Container(
                child: Text("Your favorite list is empty"),
              );
            } else if (_profile.favorite.length == 0)
              return Container(
                child: Text("Your favorite list is empty"),
              );

            return Container(
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  itemCount: _profile.favorite.length,
                  itemBuilder: (context, index) {
                    var item = Firestore.instance
                        .document("${_profile.favorite[index]}")
                        .snapshots();

                    return StreamBuilder(
                        stream: item,
                        builder: (context, snapshot) {
                          if (snapshot == null) return Container();

                          DocumentSnapshot _doc = snapshot.data;
                          if (_doc == null) return Container();

                          // Available time
                          Timestamp timestamp;
                          List upcoming = _doc.data['upcoming'];
                          // find the nearest available date
                          Timestamp nearestDate = upcoming[0]['date'];
                          for (var item in upcoming) {
                            Timestamp date = item['date'];
                            if (date.compareTo(nearestDate) < 0)
                              nearestDate = date;
                          }
                          timestamp = nearestDate;

                          Text avaliableDate;
                          if (timestamp.toDate().year <= DateTime.now().year &&
                              timestamp.toDate().month <=
                                  DateTime.now().month &&
                              timestamp.toDate().day <= DateTime.now().day) {
                            avaliableDate = Text(
                              "Available Now",
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            );
                          } else {
                            avaliableDate = Text(
                              "Next Available: " +
                                  "${timestamp.toDate().year}/" +
                                  "${timestamp.toDate().month}/" +
                                  "${timestamp.toDate().day}",
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            );
                          }

                          // Price
                          Row price = Row(
                            children: <Widget>[
                              Text(
                                "\$${_doc.data['price']['amount']}",
                                style: textTheme.body2,
                              ),
                              Text("\\${_doc.data['price']['currency']} "),
                            ],
                          );

                          Card card = Card(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 120,
                                    // width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                      ),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          _doc.data['images'][0],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: ListTile(
                                    title: Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            _doc.data['title'],
                                            maxLines: 1,
                                            style: textTheme.title,
                                          ),
                                          FavoriteWidget(
                                              path: _doc.reference.path),
                                        ],
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        price,
                                        Text(
                                            "${_doc.data['address']['line_1']}"),
                                        Text("${_doc.data['type'][0].toUpperCase()}" +
                                            "${_doc.data['type'].substring(1)}"),
                                        avaliableDate,
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                          return InkWell(
                            child: card,
                            onTap: () {
                              Navigator.of(context).pushNamed('/detail',
                                  arguments: {
                                    'data': _doc.data,
                                    'documentID': _doc.documentID,
                                    'document': _doc
                                  });
                            },
                          );
                        });
                  }),
            );
          },
        ),
      ),
    );
  }
}
