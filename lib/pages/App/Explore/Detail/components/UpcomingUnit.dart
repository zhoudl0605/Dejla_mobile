import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpcomingUnit extends StatefulWidget {
  UpcomingUnit({Key key}) : super(key: key);

  @override
  _UpcomingUnitState createState() => _UpcomingUnitState();
}

class _UpcomingUnitState extends State<UpcomingUnit> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Consumer<DocumentSnapshot>(
      builder: (BuildContext context, DocumentSnapshot value, Widget child) {
        List upcomingUnit = value.data['upcoming'];

        return Card(
          elevation: 5,
          child: ListTile(
            title: Text(
              "Upcoming unit",
              style: textTheme.headline6,
            ),
            subtitle: Builder(
              builder: (context) {
                if (upcomingUnit.length == 0)
                  return Text(
                    "Currently no upcoming unit",
                    style: textTheme.headline6,
                  );
                List<DataRow> dataRows = [];
                upcomingUnit.forEach((_val) {
                  Timestamp time = _val['date'];

                  dataRows.add(DataRow(cells: [
                    DataCell(Text("${_val['unitID']}")),
                    DataCell(Text('${time.toDate().year}-' +
                        '${time.toDate().month}-' +
                        '${time.toDate().day}')),
                  ]));
                });

                return DataTable(
                    sortAscending: false,
                    sortColumnIndex: 0,
                    showCheckboxColumn: true,
                    columns: [
                      DataColumn(
                        label: Text("Unit ID"),
                        tooltip: "The unit id of the available unit",
                      ),
                      DataColumn(
                        label: Text("Available date"),
                        tooltip: "The date you can move into the available unit",
                      ),
                    ],
                    rows: dataRows);
              },
            ),
          ),
        );
      },
    );
  }
}
