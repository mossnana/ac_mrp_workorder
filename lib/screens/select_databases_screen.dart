

import 'package:flutter/material.dart';

class SelectDatabasesScreen extends StatelessWidget {
  List<dynamic> databasesList = [];

  SelectDatabasesScreen({this.databasesList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Databases'),),
      body: ListView.builder(
          itemCount: databasesList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(databasesList[index]),
              onTap: () async {
                Navigator.pop(context, databasesList[index]);
              },
            );
          }
      ),
    );
  }
}