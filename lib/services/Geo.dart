import 'package:geolocator/geolocator.dart';

class GeoService {
  Geolocator _geolocator = Geolocator()..forceAndroidLocationManager = true;

  Future getCurrentPosition() async {
    try {
      Position position = await _geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      List<Placemark> list = await _geolocator.placemarkFromPosition(position);
      Placemark placemark = list[0];

      // print(placemark.toJson().toString());
      return placemark;
    } catch (err) {
      print(err.toString());
    }
  }

  Future getPlacemark(String input) async {
    try {
      // print(input);

      List<Placemark> result = await Geolocator().placemarkFromAddress(input);
      Placemark placemark = result[0];

      // result.forEach((place) {
      //   print(place.toJson().toString());
      // });

      return placemark;
    } catch (err) {
      print(err.toString());
    }
  }

  getGeoPosition(String input) async {
    try {
      var result = await _geolocator.placemarkFromAddress(input);
      // print(result[0].toJson().toString());
      return result[0].position;
    } catch (err) {
      print(err.toString());
    }
  }
}
