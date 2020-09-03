import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dejla/modules/SearchFilter.dart';
import 'package:dejla/services/Search.dart';
import 'package:dejla/widget/Favorite_Widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:getflutter/getflutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

const API_KEY = 'AIzaSyA5DXsnpdc7Kk7s_Wzcyn4XH9vLlIpNcCg';

class ExplorePage extends StatefulWidget {
  ExplorePage({Key key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  TextEditingController searchController = new TextEditingController();
  var uuid = new Uuid();
  String _sessionToken;
  List<String> _displayResults = [];
  bool searchList = false;
  Timer _throttle;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    SearchService search = Provider.of<SearchService>(context);
    SearchFilter filter = search.filter;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GFColors.WHITE,
        leading: GFIconButton(
          icon: Icon(
            FontAwesome.sliders,
            color: GFColors.PRIMARY,
          ),
          size: GFSize.LARGE,
          color: GFColors.WHITE,
          onPressed: () {
            if (filter.location != "") return Scaffold.of(context).openDrawer();
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Please select a location"),
              duration: Duration(seconds: 1),
            ));
          },
        ),
        title: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            top: 13,
          ),
          child: GFSearchBar(
            overlaySearchListHeight: 260,
            searchList: _displayResults,
            searchQueryBuilder: (query, list) {
              //TODO: add feature to get current address

              getLocationResults(query);
              return list;
            },
            overlaySearchListItemBuilder: (item) {
              return Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  item,
                  style: textTheme.bodyText1,
                ),
              );
            },
            onItemSelected: (item) {
              if (item == null) return _displayResults.clear();
              setState(() {
                filter.location = item;
                search.notify();
                search.searchProperty();
              });
            },
          ),
        ),
        // TODO: unlock map feature in the next iteration
        // actions: <Widget>[
        //   GFIconButton(
        //     color: GFColors.WHITE,
        //     size: GFSize.LARGE,
        //     icon: Icon(
        //       Icons.map,
        //       color: GFColors.PRIMARY,
        //     ),
        //     onPressed: () {},
        //   ),
        // ],
        centerTitle: true,
        bottom: filter.location == ""
            ? null
            : PreferredSize(
                preferredSize: Size.fromHeight(40),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 40,
                  child: Consumer<SearchService>(
                    builder: (BuildContext context, value, Widget child) {
                      List<Widget> list = [];
                      if (value.filter.location == null) return Container();

                      if (value.filter.location != "")
                        list.add(Chip(
                          label: Text("${value.filter.location.split(',')[0]}"),
                          onDeleted: () {
                            value.filter.location = "";
                            search.resetResult();
                            value.notify();
                          },
                        ));
                      list.add(
                        Chip(
                          label: Text("${value.filter.distance.toInt()} km"),
                          // onPressed: () {
                          //   setState(() {
                          //     Scaffold.of(context).openDrawer();
                          //   });
                          // },
                        ),
                      );
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return list[index];
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(width: 5);
                        },
                      );
                    },
                  ),
                ),
              ),
      ),
      backgroundColor: GFColors.WHITE,
      body: Consumer<SearchService>(
        builder: (BuildContext context, value, Widget child) {
          if (value.filter.location == "")
            return Container(
              alignment: Alignment.bottomCenter,
              // height: 300,
              child: Image.asset('assets/need_location.png'),
            );
          return Consumer<SearchService>(
            builder: (BuildContext context, value, Widget child) {
              return Builder(
                builder: (context) {
                  List<DocumentSnapshot> data = value.filteredFloorPlans;

                  if (value.floorPlans == null) {
                    print("no result");

                    return GFLoader(
                      size: GFSize.LARGE,
                      duration: Duration(milliseconds: 100),
                    );
                  }

                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        var doc = data[index].data;

                        // Available time
                        Timestamp timestamp;
                        List upcoming = doc['upcoming'];
                        // find the nearest available date
                        Timestamp nearestDate = upcoming[0]['date'];
                        for (var item in upcoming) {
                          Timestamp date = item['date'];
                          if (date.compareTo(nearestDate) < 0)
                            nearestDate = date;
                        }
                        timestamp = nearestDate;

                        // Build available date
                        Text avaliableDate;
                        if (timestamp.toDate().year <= DateTime.now().year &&
                            timestamp.toDate().month <= DateTime.now().month &&
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
                              "\$${doc['price']['amount']}",
                              style: textTheme.bodyText1,
                            ),
                            Text("\\${doc['price']['currency']} "),
                          ],
                        );

                        return InkWell(
                          child: Card(
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
                                          doc['images'][0],
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
                                            doc['title'],
                                            maxLines: 1,
                                            style: textTheme.headline6,
                                          ),
                                          FavoriteWidget(
                                              path: data[index].reference.path),
                                        ],
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        price,
                                        Text("${doc['address']['line_1']}"),
                                        Text("${doc['type'][0].toUpperCase()}" +
                                            "${doc['type'].substring(1)}"),
                                        avaliableDate,
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/detail',
                              arguments: {
                                'data': doc,
                                'documentID': data[index].documentID,
                                'document': data[index]
                              },
                            );
                          },
                        );
                      });
                },
              );
            },
          );
        },
      ),
    );
  }

  // Search place
  void getLocationResults(String input) async {
    try {
      if (_throttle?.isActive ?? false) _throttle.cancel();
      _throttle = Timer(const Duration(milliseconds: 100), () async {
        String baseURL =
            'https://maps.googleapis.com/maps/api/place/autocomplete/json';
        // String type = 'establishment';

        String request = '$baseURL?input=$input' +
            '&key=$API_KEY' +
            // '&type=$type' +
            '&sessiontoken=$_sessionToken' +
            '&components=country:ca';
        Response response = await Dio()
            .get(request)
            .timeout(Duration(seconds: 10))
            .catchError((err) {
          print(err.toString());
        });

        final predictions = response.data['predictions'];
        setState(() {
          _displayResults.clear();
        });

        for (int i = 0; i < predictions.length; i++) {
          // print(predictions[i].toString());
          String name = predictions[i]['description'];
          setState(() {
            _displayResults.add(name);
          });
        }
      });
    } catch (err) {
      print(err);
    }
  }
}
