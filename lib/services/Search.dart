import 'dart:async';

import 'package:dejla/modules/SearchFilter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dejla/services/Geo.dart';
import 'package:flutter/widgets.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

const double MILE_TO_KM = 1.609344;

class SearchService with ChangeNotifier {
// class SearchService {
  Stream<List<DocumentSnapshot>> searchResult;
  List<DocumentSnapshot> floorPlans;
  List<DocumentSnapshot> filteredFloorPlans;

  SearchFilter filter;
  StreamSubscription _subscription;

  SearchService() {
    filter = new SearchFilter();
  }

  //Function veriables
  Timer _throttle;

  get result {
    return searchResult;
  }

  resetResult() {
    clear();
    floorPlans = null;
  }

  // get search result
  Future searchProperty() async {
    try {
      if (filter.location == "") return;
      if (_throttle?.isActive ?? false) _throttle.cancel();

      _throttle = Timer(const Duration(milliseconds: 500), () async {
        Query _collectionRef = Firestore.instance.collectionGroup('floorPlan');
        GeoService geoService = new GeoService();
        Geoflutterfire geoFire = Geoflutterfire();

        Position position =
            await geoService.getGeoPosition("${filter.location}");

        GeoFirePoint center = geoFire.point(
            latitude: position.latitude, longitude: position.longitude);

        if (floorPlans != null) floorPlans.clear();
        clear();

        _subscription = geoFire
            .collection(collectionRef: _collectionRef)
            .within(
                center: center,
                radius: filter.distance,
                field: 'position',
                strictMode: true)
            .listen((data) {
          floorPlans = data;
          filterFloorPlan();
          notifyListeners();
        });

        notifyListeners();
      });
    } catch (err) {
      print(err.toString());
      // return err;
    }
  }

  changeDistance(double distance) {
    this.filter.distance = distance;
    notify();
    searchProperty();
  }

  // rebuild the result list
  filterFloorPlan() {
    List<DocumentSnapshot> list = [];
    List<String> types = [];
    for (int i = 0; i < UNIT_TYPES.length; i++) {
      if (filter.types[i] == true) types.add(UNIT_TYPES[i]);
    }

    for (DocumentSnapshot doc in floorPlans) {
      // Check the price range
      if (doc['price']['amount'] < filter.price['min'] &&
          filter.price['min'] != NO_PREFERENCE) {
        continue;
      }
      if (doc['price']['amount'] > filter.price['max'] &&
          filter.price['max'] != NO_PREFERENCE) {
        continue;
      }

      // Check unit type
      bool flag = false;
      if (types.isEmpty)
        flag = true;
      else
        for (var item in types) if (item == doc['type']) flag = true;
      if (flag == false) continue;

      // Check number of bedroom
      if (filter.bedroom != NO_PREFERENCE) {
        if (filter.bedroom < 5) {
          if (filter.bedroom != doc['bedroom']) continue;
        } else if (doc['bedroom'] < 5) continue;
      }

      // Check number of bathroom
      if (filter.bathroom != NO_PREFERENCE) {
        if (filter.bathroom < 5) {
          if (filter.bathroom != doc['bathroom']) continue;
        } else if (doc['bathroom'] < 5) continue;
      }

      //If all satisfied
      list.add(doc);
    }

    filteredFloorPlans = list;

    notify();
  }

  // reset the filter
  resetFilter() {
    filter = new SearchFilter(location: filter.location);
    filterFloorPlan();
  }

  notify() {
    notifyListeners();
  }

  clear() {
    if (_subscription == null) return;
    _subscription.cancel();
  }
}

SearchService searchService = SearchService();
