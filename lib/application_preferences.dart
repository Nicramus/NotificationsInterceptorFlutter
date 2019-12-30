import 'package:flutter/material.dart';
import 'package:flutter_app/list.dart';
import 'package:logging/logging.dart';

class ApplicationPreferences extends StatelessWidget {
  final Logger log = new Logger('ApplicationPreferences');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forwarding preferences"),
      ),
      body:  SwitchListTile(
        value: false,
        title: Text("Forward notifications"),
        onChanged: (value) {}),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
          print("On Pressed");
        },
        icon: Icon(Icons.add),
        label: Text('Add new filter'),
        backgroundColor: Colors.blue,
      )
    );
  }
}