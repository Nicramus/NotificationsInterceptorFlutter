import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class ApplicationPreferences extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ApplicationPreferencesState();
}

class ApplicationPreferencesState extends State<ApplicationPreferences> {
  final Logger log = new Logger('ApplicationPreferences');

  bool isForwardingOn = false;

  List<NotificationFilter> list = List();

  void onForwardingChanged(param) {}

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
                    title: Text(item.filterName))
                );
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

  void editRule(context, item) {}

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
      setState(() {});
    });
  }
}

/**
 * Class which represents forwarding rule
 */
class NotificationFilter {
  String filterName;
  String key;
  String titleFilterValue;

  NotificationFilter() {
    this.key = randomString(10);
  }

  String randomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(
        length,
            (index){
          return rand.nextInt(33)+89;
        }
    );

    return new String.fromCharCodes(codeUnits);
  }

}

/**
 * Class which contains dialog for setting a new rule
 */
class FilterRuleDialog extends StatefulWidget {

  List<NotificationFilter> list;

  FilterRuleDialog(List<NotificationFilter> list) {
    this.list = list;
  }

  @override
  State<StatefulWidget> createState() => FilterRuleDialogState(list);
}

class FilterRuleDialogState extends State<FilterRuleDialog> {
  final String createTitleDialog = "Create a new notification filter";
  final String editTitleDialog = "Edit an exising rule";
  String dropdownValue = 'Accepting';

  final textEditingController = TextEditingController();
  List<NotificationFilter> list;

  FilterRuleDialogState(List<NotificationFilter> list) {
    this.list = list;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: dialogContent(context));
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                createTitleDialog,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: textEditingController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.label),
                  hintText: 'Name of the rule visible on the list',
                  labelText: 'Filter name',
                ),
                onSaved: (String value) {
                  print(value);
                },
                validator: (String value) {
                  return value.contains('@') ? 'Do not use the @ char.' : null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.filter_list),
                  hintText: 'Name of the rule visible on the list',
                  labelText: 'Notifications Title contains',
                ),
                onSaved: (String value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                validator: (String value) {
                  return value.contains('@') ? 'Do not use the @ char.' : null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButton<String>(
                value: dropdownValue,
                //icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: "Accepting",
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.thumb_up, color: Colors.green),
                        Text('Accepting'),
                      ],
                    )),
                  DropdownMenuItem<String>(
                      value: "Rejecting",
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.block, color: Colors.red),
                          Text('Rejecting'),
                        ],
                      ))
                ]
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: () {
                    print(textEditingController.text);
                    print(list);
                    NotificationFilter forwardingRule = NotificationFilter();
                    forwardingRule.filterName = textEditingController.text;
                    list.add(forwardingRule);
                    Navigator.of(context).pop(); // To close the dialog
                  },
                  child: Text("CREATE"),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

}
