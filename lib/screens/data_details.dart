import 'package:flutter/material.dart';

class DataDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('Data Table'),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                    'Points',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Airtime (GHS)',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Data (Mb)',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Mobile Money (GHS)',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('600')),
                    DataCell(Text('5')),
                    DataCell(Text('500')),
                    DataCell(Text('5')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('1500')),
                    DataCell(Text('10')),
                    DataCell(Text('800')),
                    DataCell(Text('10')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('3000')),
                    DataCell(Text('20')),
                    DataCell(Text('1300')),
                    DataCell(Text('20')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('6000')),
                    DataCell(Text('30')),
                    DataCell(Text('2000')),
                    DataCell(Text('30')),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
