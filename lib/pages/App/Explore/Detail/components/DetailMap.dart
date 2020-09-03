import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class DetailMap extends StatefulWidget {
  DetailMap({Key key}) : super(key: key);

  @override
  _DetailMapState createState() => _DetailMapState();
}

class _DetailMapState extends State<DetailMap> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentSnapshot>(
      builder: (BuildContext context, DocumentSnapshot value, Widget child) {
        return AspectRatio(
          aspectRatio: 16 / 6,
          child: GoogleMap(
            onMapCreated: (GoogleMapController controller) {},
            initialCameraPosition: CameraPosition(
                target: LatLng(
                  value.data['position']['geopoint'].latitude,
                  value.data['position']['geopoint'].longitude,
                ),
                zoom: 14.0),
            rotateGesturesEnabled: false,
            scrollGesturesEnabled: false,
            tiltGesturesEnabled: false,
            compassEnabled: true,
            markers: {
              Marker(
                draggable: false,
                markerId: MarkerId('building'),
                position: LatLng(value.data['position']['geopoint'].latitude,
                    value.data['position']['geopoint'].longitude),
              ),
            },
          ),
        );
      },
    );
  }
}
