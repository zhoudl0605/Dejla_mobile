import 'package:flutter/material.dart';

class BuildingUnitsPage extends StatefulWidget {
  final Map arguments;

  BuildingUnitsPage({Key key, this.arguments}) : super(key: key);

  @override
  _BuildingUnitsPageState createState() =>
      _BuildingUnitsPageState(arguments: this.arguments);
}

class _BuildingUnitsPageState extends State<BuildingUnitsPage> {
  final Map arguments;
  _BuildingUnitsPageState({this.arguments});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("${arguments['buildingID']}"),
    );
  }
}
