import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class UnitDetailWidget extends StatefulWidget {
  UnitDetailWidget({Key key, this.data}) : super(key: key);
  final Map data;

  @override
  _UnitDetailWidgetState createState() => _UnitDetailWidgetState();
}

class _UnitDetailWidgetState extends State<UnitDetailWidget> {
  @override
  Widget build(BuildContext context) {
    Map data = widget.data;
    int bedroom = data['bedroom'];

    List<Widget> include = [
      Icon(
        Icons.check,
        color: Colors.green,
      ),
      Text("Included"),
    ];

    List<Widget> notInclude = [
      Icon(
        Icons.close,
        color: Colors.red,
      ),
      Text("Not Included"),
    ];

    Widget close = Icon(
      Icons.close,
      color: Colors.red,
    );

    Widget check = Icon(
      Icons.check,
      color: Colors.green,
    );

    return DefaultTabController(
      length: 3,
      child: Column(
        children: <Widget>[
          Container(
            child: TabBar(
              labelColor: Colors.blueAccent,
              tabs: [
                Tab(text: "Overview"),
                Tab(text: "Unit"),
                Tab(text: "Building"),
              ],
            ),
          ),
          SizedBox(
            height: 480,
            child: TabBarView(
              children: [
                // Overview
                Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(MaterialCommunityIcons.home_city_outline),
                        title: Text("Unit Type"),
                        subtitle: Text("${data['type'][0].toUpperCase()}" +
                            "${data['type'].substring(1)}"),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(FontAwesome.bed),
                        title: Text("Bedroom"),
                        subtitle: Text(
                            bedroom == 0 ? "Studio" : "${data['bedroom']}"),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(FontAwesome.bath),
                        title: Text("Bathroom"),
                        subtitle: Text("${data['bathroom']}"),
                        dense: true,
                      ),
                      Builder(builder: (context) {
                        if (data['den'] > 0)
                          return ListTile(
                            leading: Icon(MaterialCommunityIcons.door),
                            title: Text("Den"),
                            subtitle: Text("${data['den']}"),
                            dense: true,
                          );
                        return Container();
                      }),
                      Builder(builder: (context) {
                        if (data['halfBathroom'] > 0)
                          return ListTile(
                            leading: Icon(MaterialCommunityIcons.toilet),
                            title: Text("Half Bathroom"),
                            subtitle: Text("${data['halfBathroom']}"),
                            dense: true,
                          );
                        return Container();
                      }),
                      ListTile(
                        leading: Icon(FontAwesome.tint),
                        title: Text("Utilities"),
                        subtitle: Column(
                          children: <Widget>[
                            Row(children: [
                              (data['utility_heat'] == true ? check : close),
                              Text("Heat")
                            ]),
                            Row(children: [
                              (data['utility_power'] == true ? check : close),
                              Text("Power")
                            ]),
                            Row(children: [
                              (data['utility_water'] == true ? check : close),
                              Text("Water")
                            ]),
                          ],
                        ),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(MaterialCommunityIcons.paw),
                        title: Text("Pet Friendly"),
                        subtitle: Text('${data['petFriendly']}'),
                        dense: true,
                      ),
                    ],
                  ),
                ),
                // Unit
                Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Entypo.ruler),
                        title: Text("Size (${data['size']['unit']})"),
                        subtitle: Text("${data['size']['amount']}"),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(MaterialCommunityIcons.sofa),
                        title: Text("Furnished"),
                        subtitle:
                            Text(data['furnished'] == true ? "Yes" : "No"),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(MaterialCommunityIcons.washing_machine),
                        title: Text("Appliances"),
                        subtitle: Column(
                          children: <Widget>[
                            Row(children: [
                              (data['appliance']['laundryInUnit'] == true
                                  ? check
                                  : close),
                              Text("Laundary(In Unit)")
                            ]),
                            Row(children: [
                              (data['appliance']['laundryInBuilding'] == true
                                  ? check
                                  : close),
                              Text("Laundary(In Building)")
                            ]),
                            Row(children: [
                              (data['appliance']['dishwasher'] == true
                                  ? check
                                  : close),
                              Text("Dishwasher")
                            ]),
                            Row(children: [
                              (data['appliance']['fridge'] == true
                                  ? check
                                  : close),
                              Text("Fridge / Freezer")
                            ]),
                          ],
                        ),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(MaterialCommunityIcons.air_conditioner),
                        title: Text("Air Conditioner"),
                        subtitle: Row(
                          children: data['airConditioner'] == true
                              ? include
                              : notInclude,
                        ),
                        dense: true,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading:
                            Icon(MaterialCommunityIcons.room_service_outline),
                        title: Text("Amenities"),
                        subtitle: Column(
                          children: <Widget>[
                            Row(children: [
                              (data['amenity']['gym'] == true ? check : close),
                              Text("GYM")
                            ]),
                            Row(children: [
                              (data['amenity']['security'] == true
                                  ? check
                                  : close),
                              Text("Security")
                            ]),
                            Row(children: [
                              (data['amenity']['storage'] == true
                                  ? check
                                  : close),
                              Text("Storage"),
                            ]),
                            Row(children: [
                              (data['amenity']['elevator'] == true
                                  ? check
                                  : close),
                              Text("Elevator"),
                            ]),
                            Row(children: [
                              (data['amenity']['pool'] == true ? check : close),
                              Text("Pool"),
                            ]),
                            Row(children: [
                              (data['amenity']['concierge'] == true
                                  ? check
                                  : close),
                              Text("Concierge"),
                            ]),
                            Row(children: [
                              (data['amenity']['bicycleParking'] == true
                                  ? check
                                  : close),
                              Text("Bicycle Parking"),
                            ]),
                            Row(children: [
                              (data['amenity']['vehicleParking'] == true
                                  ? check
                                  : close),
                              Text("Vehicle Parking"),
                            ]),
                          ],
                        ),
                        dense: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
