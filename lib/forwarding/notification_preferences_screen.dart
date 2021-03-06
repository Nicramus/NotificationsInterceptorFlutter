import 'package:flutter/material.dart';
import 'package:flutter_app/forwarding/filter_rules_dialog.dart';
import 'package:logging/logging.dart';

import 'notification_filter.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NotificationPreferencesScreenState();
}

class NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  final Logger log = new Logger('ApplicationPreferences');

  bool isForwardingOn = false;

  List<NotificationFilter> list = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Forwarding preferences"),
        ),
        body: new Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SwitchListTile(
              value: isForwardingOn,
              onChanged: onForwardingChanged,
              title: new Text('Forward notifications'),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                NotificationFilter item = list[index];
                return Dismissible(
                    key: Key(item.key),
                    onDismissed: (direction) {
                      setState(() {
                        list.removeAt(index);
                      });
                    },
                    background: Container(color: Colors.red),
                    child: ListTile(
                        onTap: () => editRule(context, item),
                        title: Text(item.filterName)));
              },
            ))
          ],
        )),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            createNewRule(list);
          },
          icon: Icon(Icons.add),
          label: Text('Add new filter'),
          backgroundColor: Colors.blue,
        ));
  }

  void onForwardingChanged(param) {}

  void editRule(BuildContext context, NotificationFilter item) async {
    await showDialog(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (ctx, setState) {
              return new FilterRuleDialog.edit(list, item);
            },
          );
        }).then((val) {
      setState(() {}); //after dialog disposal - set listview state
    });
  }

  void createNewRule(List<NotificationFilter> list) async {
    await showDialog(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (ctx, setState) {
              return FilterRuleDialog(list);
            },
          );
        }).then((val) {
      setState(() {}); //after dialog disposal - set listview state
    });
  }
}
