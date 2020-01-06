import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'notification_filter.dart';

/**
 * Class which contains dialog for setting a new rule
 * TODO return as success (when create is done) the NotificationFilter object
 * TODO remove list reference
 * TODO add validation - prevent before creation of an empty filter rule
 */
class FilterRuleDialog extends StatefulWidget {
  List<NotificationFilter> list;
  NotificationFilter item;

  FilterRuleDialog(this.list);

  FilterRuleDialog.fromFilterRuleDialog(FilterRuleDialog dialog)
      : list = dialog.list,
        item = dialog.item;

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
                  ]),
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
