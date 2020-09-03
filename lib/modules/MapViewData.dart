import 'package:cloud_firestore/cloud_firestore.dart';

class MapViewData {
  String buildingID;
  String icon;
  String title;
  GeoPoint geoPoint;
  List<DocumentSnapshot> items;
  String type = "unit";

  MapViewData(
      {this.buildingID, this.icon, this.title, this.geoPoint, this.items});

  // update type
  void updateType() {
    if (items.length > 1) type = "building";
  }

  void addItem(DocumentSnapshot newItem) {
    items.add(newItem);
    updateType();
  }
}
