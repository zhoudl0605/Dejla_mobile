import 'package:dejla/modules/SearchFilter.dart';
import 'package:dejla/services/Search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getflutter/getflutter.dart';
import 'package:provider/provider.dart';

const NO_PREFERENCE = -1;

class SearchDrawer extends StatefulWidget {
  SearchDrawer({Key key}) : super(key: key);

  @override
  _SearchDrawerState createState() => _SearchDrawerState();
}

class _SearchDrawerState extends State<SearchDrawer> {
  //Controllers
  //  min price
  final TextEditingController _minPriceController = new TextEditingController();
  //  max price
  final TextEditingController _maxPriceController = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    var search = Provider.of<SearchService>(context);
    var _filter = search.filter;

    // price range text
    if (_filter.price['min'] > 0 && _minPriceController.text.isEmpty)
      _minPriceController.text = _filter.price['min'].toString();
    if (_filter.price['max'] > 0 && _maxPriceController.text.isEmpty)
      _maxPriceController.text = _filter.price['max'].toString();

    return Drawer(
      child: Scaffold(
        backgroundColor: GFColors.WHITE,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            "Search",
            style: textTheme.headline6,
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  search.filteredFloorPlans.length.toString() + ' results',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyText2,
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Builder(builder: (context) {
            List<ExpansionPanelRadio> _list = [];
            List<int> distance = [5, 10, 15, 25, 50, 100];
            List<int> bedroom = [-1, 0, 1, 2, 3, 4, 5];
            List<int> bathroom = [-1, 1, 2, 3, 4, 5];
            // distance
            _list.add(
              ExpansionPanelRadio(
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text(
                      "Maximum distance",
                      style: textTheme.caption,
                    ),
                    subtitle: Text(
                      "${_filter.distance.toInt()} km",
                      style: textTheme.bodyText2,
                    ),
                  );
                },
                body: ListView.builder(
                  itemCount: distance.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: ListTile(
                        title: Text(
                          distance[index].toString() + " km",
                          style: textTheme.bodyText2,
                        ),
                        trailing: Builder(
                          builder: (context) =>
                              distance[index] == _filter.distance
                                  ? Icon(
                                      Icons.check,
                                    )
                                  : SizedBox(),
                        ),
                        onTap: () {
                          search.changeDistance(distance[index].toDouble());
                        },
                      ),
                    );
                  },
                ),
                value: "distance",
              ),
            );

            // price range
            _list.add(
              ExpansionPanelRadio(
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: (_filter.price['max'] == NO_PREFERENCE &&
                            _filter.price['min'] == NO_PREFERENCE)
                        ? Text(
                            "Price",
                            style: textTheme.bodyText2,
                          )
                        : Text(
                            "Price",
                            style: textTheme.caption,
                          ),
                    subtitle: (_filter.price['max'] == NO_PREFERENCE &&
                            _filter.price['min'] == NO_PREFERENCE)
                        ? null
                        : Builder(
                            builder: (context) {
                              String _text = "";
                              if (_filter.price['max'] == NO_PREFERENCE)
                                _text = 'From ${_filter.price['min']}';
                              else if (_filter.price['min'] == NO_PREFERENCE)
                                _text = 'Under ${_filter.price['max']}';
                              else
                                _text =
                                    '${_filter.price['min']} - ${_filter.price['max']}';
                              return Text(
                                _text,
                                style: textTheme.bodyText2,
                              );
                            },
                          ),
                  );
                },
                body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          "Any",
                          style: textTheme.bodyText2,
                        ),
                        trailing: Builder(
                          builder: (context) =>
                              (_filter.price['max'] == NO_PREFERENCE &&
                                      _filter.price['min'] == NO_PREFERENCE)
                                  ? Icon(
                                      Icons.check,
                                    )
                                  : SizedBox(),
                        ),
                        onTap: () {
                          _filter.price = {
                            'max': NO_PREFERENCE,
                            'min': NO_PREFERENCE,
                          };
                          _minPriceController.text = "";
                          _maxPriceController.text = "";
                          search.filterFloorPlan();
                        },
                      ),
                      ListTile(
                        title: Text(
                          "Price Range",
                          style: textTheme.bodyText2,
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: <Widget>[
                              TextField(
                                style: textTheme.bodyText2,
                                controller: _minPriceController,
                                decoration:
                                    InputDecoration(hintText: 'Minimum Price'),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                onChanged: (val) {
                                  if (val == "")
                                    _filter.price['min'] = NO_PREFERENCE;
                                  else
                                    _filter.price['min'] = num.parse(val);
                                  search.filterFloorPlan();
                                },
                              ),
                              TextField(
                                style: textTheme.bodyText2,
                                controller: _maxPriceController,
                                decoration:
                                    InputDecoration(hintText: 'Maximum Price'),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                onChanged: (val) {
                                  if (val == "")
                                    _filter.price['max'] = NO_PREFERENCE;
                                  else
                                    _filter.price['max'] = num.parse(val);
                                  search.filterFloorPlan();
                                },
                              ),
                            ],
                          ),
                        ),
                        trailing: Builder(
                          builder: (context) =>
                              (_filter.price['max'] == NO_PREFERENCE &&
                                      _filter.price['min'] == NO_PREFERENCE)
                                  ? SizedBox()
                                  : Icon(
                                      Icons.check,
                                    ),
                        ),
                      ),
                    ],
                  ),
                ),
                value: "priceRange",
              ),
            );

            // unit types
            _list.add(ExpansionPanelRadio(
              canTapOnHeader: true,
              value: 'unitTypes',
              headerBuilder: (BuildContext context, bool isExpanded) {
                String _text = "";
                int _count = 0;
                for (int i = 0; i < _filter.types.length; i++) {
                  if (_filter.types[i]) {
                    _count++;
                    _text = UNIT_TYPES[i];
                  }
                }

                return ListTile(
                  title: _count == 0
                      ? Text(
                          "Unit type",
                          style: textTheme.bodyText2,
                        )
                      : Text(
                          "Unit type",
                          style: textTheme.caption,
                        ),
                  subtitle: _count == 0
                      ? null
                      : Text(
                          _count == 1
                              ? '${_text[0].toUpperCase()}${_text.substring(1)}'
                              : '$_count items selected',
                          style: textTheme.bodyText2,
                        ),
                );
              },
              body: ListTile(
                title: Builder(builder: (BuildContext context) {
                  List<Widget> _list = [];
                  for (int i = 0; i < UNIT_TYPES.length; i++) {
                    _list.add(ChoiceChip(
                      label: Text(UNIT_TYPES[i][0].toUpperCase() +
                          UNIT_TYPES[i].substring(1)),
                      selected: _filter.types[i],
                      onSelected: (val) {
                        _filter.types[i] = val;
                        search.filterFloorPlan();
                      },
                    ));
                  }
                  return Wrap(
                    spacing: 5,
                    children: _list,
                  );
                }),
              ),
            ));

            // Bedrooms
            _list.add(
              ExpansionPanelRadio(
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  String title = "";
                  if (_filter.bedroom < 0)
                    title = "";
                  else if (_filter.bedroom == 0)
                    title = "Studio/Bachelor";
                  else
                    title = "${_filter.bedroom}";

                  return ListTile(
                    title: title == ""
                        ? Text(
                            "Bedrooms",
                            style: textTheme.bodyText2,
                          )
                        : Text(
                            "Bedrooms",
                            style: textTheme.caption,
                          ),
                    subtitle: title == ""
                        ? null
                        : Text(
                            _filter.bedroom == 0 ? title : "${_filter.bedroom}",
                            style: textTheme.bodyText2,
                          ),
                  );
                },
                body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.builder(
                    itemCount: bedroom.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      String item = '';
                      if (bedroom[index] == NO_PREFERENCE)
                        item = "No preference";
                      else if (bedroom[index] == 0)
                        item = "Studio/Bachelor";
                      else if (bedroom[index] == 1)
                        item = "${bedroom[index]} bedroom";
                      else
                        item = "${bedroom[index]} bedrooms";

                      return ListTile(
                        title: Text(
                          item,
                          style: textTheme.bodyText2,
                        ),
                        trailing: Builder(
                          builder: (context) =>
                              bedroom[index] == _filter.bedroom
                                  ? Icon(
                                      Icons.check,
                                    )
                                  : SizedBox(),
                        ),
                        onTap: () {
                          _filter.bedroom = bedroom[index];
                          search.filterFloorPlan();
                        },
                      );
                    },
                  ),
                ),
                value: "bedroom",
              ),
            );

            // Bathrooms
            _list.add(
              ExpansionPanelRadio(
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  String title = "";
                  if (_filter.bathroom < 0)
                    title = "";
                  else
                    title = "${_filter.bathroom}";

                  return ListTile(
                    title: title == ""
                        ? Text(
                            "Bathrooms",
                            style: textTheme.bodyText2,
                          )
                        : Text(
                            "Bathrooms",
                            style: textTheme.caption,
                          ),
                    subtitle: title == ""
                        ? null
                        : Text(
                            title,
                            style: textTheme.bodyText2,
                          ),
                  );
                },
                body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.builder(
                    itemCount: bathroom.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      String item = '';
                      if (bathroom[index] == NO_PREFERENCE)
                        item = "No preference";
                      else if (bathroom[index] == 5)
                        item = "${bathroom[index]}+";
                      else
                        item = "${bathroom[index]}";

                      return ListTile(
                        title: Text(
                          item,
                          style: textTheme.bodyText2,
                        ),
                        trailing: Builder(
                          builder: (context) =>
                              bathroom[index] == _filter.bathroom
                                  ? Icon(
                                      Icons.check,
                                    )
                                  : SizedBox(),
                        ),
                        onTap: () {
                          _filter.bathroom = bathroom[index];
                          search.filterFloorPlan();
                        },
                      );
                    },
                  ),
                ),
                value: "bathroom",
              ),
            );

            return ExpansionPanelList.radio(
              children: _list,
            );
          }),
        ),
        bottomNavigationBar: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                  onPressed: () {
                    _minPriceController.text = "";
                    _maxPriceController.text = "";
                    search.resetFilter();
                    search.filterFloorPlan();
                    // Navigator.of(context).pop();
                  },
                  child: Text("RESET")),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("APPLY")),
            ],
          ),
        ),
      ),
    );
  }
}

generateItem(int index) {
  var data = [];
  for (int i = 0; i < index; i++) {
    data.add(false);
  }
  return data;
}
