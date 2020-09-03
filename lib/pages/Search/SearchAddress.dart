import 'package:dejla/services/Geo.dart';
import 'package:dejla/services/Search.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

const API_KEY = 'AIzaSyA5DXsnpdc7Kk7s_Wzcyn4XH9vLlIpNcCg';

class SearchAddressPage extends StatefulWidget {
  final Map arguments;
  
  SearchAddressPage({Key key, this.arguments}) : super(key: key);

  @override
  _SearchAddressPageState createState() =>
      _SearchAddressPageState(arguments: this.arguments);
}

class _SearchAddressPageState extends State<SearchAddressPage> {
  final Map arguments;
  _SearchAddressPageState({this.arguments});

  var uuid = new Uuid();
  String _sessionToken;
  List<String> _displayResults = [];
  GeoService geo = new GeoService();
  TextEditingController _controller = new TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    var _filter = Provider.of<SearchService>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: TextField(
            controller: _controller,
            autofocus: true,
            style: textTheme.subtitle,
            onChanged: (text) {
              if (_sessionToken == null)
                setState(() {
                  _sessionToken = uuid.v4();
                });
              getLocationResults(text);
            },
          ),
        ),
        body: ListView.separated(
            separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Divider(
                    height: 0,
                    color: Colors.black54,
                  ),
                ),
            itemCount: _displayResults.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text(
                    _displayResults[index],
                    style: textTheme.body1,
                  ),
                ),
                onTap: () async {
                  _sessionToken = null;
                  var data = _displayResults[index].split(", ");
                  // _filter.location.city = data[0];
                  // _filter.location.province = data[1];
                  // _filter.location.country = data[2];
                  // _filter.notify();
                  Navigator.of(context).pop();
                },
              );
            }),
      ),
    );
  }

  void getLocationResults(String input) async {
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String type = '';

    String request =
        '$baseURL?input=$input&key=$API_KEY&type=$type&sessiontoken=$_sessionToken';
    Response response = await Dio().get(request).timeout(Duration(seconds: 5));

    final predictions = response.data['predictions'];

    _displayResults = [];

    for (int i = 0; i < predictions.length; i++) {
      String name = predictions[i]['description'];
      setState(() {
        _displayResults.add(name);
      });
    }
  }

  String setSearchText(BuildContext context) {
    // var place = Provider.of<SearchFilterModel>(context).location;
    // var result;

    // if (place == null) return _controller.text = "";
    // result = "${place.city}, " + "${place.province}, " + "${place.country}";

    // return _controller.text = result;
  }
}
