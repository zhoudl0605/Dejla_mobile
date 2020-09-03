// const INI_PRICE_RANGE = {'min': double, 'max': double};
const NO_PREFERENCE = -1;
const NO_PREFERENCE_ZERO = 0;
const START_VALUE = 1;
const MAX_VALUE = 5;
const MIN_VALUE_NOT_ZERO = -1;
const MIN_VALUE = 0;
const INI_RADIUS = 10.0;
const MIN_PRICE = 0;
const MAX_PRICE = double.infinity;
const List<String> UTILITIES = ['power', 'water', 'heat'];
const List<String> UNIT_TYPES = ['apartment', 'condo', 'house', 'room'];

const INI_DISTANCE = 10;

class SearchFilter {
  Map<String, dynamic> filter;

  //Geo Filter
  String location = "";
  double radius;
  double distance;

  //Data Filter
  Map<String, int> price;

  List<bool> types;
  int bedroom;
  int bathroom;
  int halfBathroom;
  int den;
  List<bool> utilities;
  List<DateTime> pickedDate;

  // Constractor
  SearchFilter({this.location}) {
    if (this.location == null) this.location = "";

    filter = {};
    radius = INI_RADIUS;
    distance = INI_RADIUS;
    pickedDate = [
      new DateTime.now(),
      (new DateTime.now()).add(new Duration(days: 7)),
    ];

    price = {'min': NO_PREFERENCE, 'max': NO_PREFERENCE};
    types = [false, false, false, false];
    utilities = [false, false, false];

    bedroom = NO_PREFERENCE;
    bathroom = NO_PREFERENCE;
    halfBathroom = NO_PREFERENCE;
    den = NO_PREFERENCE;
  }
}

SearchFilter searchFilter = SearchFilter();
