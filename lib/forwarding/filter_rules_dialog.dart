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

  FilterRuleDialog.edit(this.list, this.item);

  @override
  State<StatefulWidget> createState() => FilterRuleDialogState(list, item);
}

class FilterRuleDialogState extends State<FilterRuleDialog> {
  final String createTitleDialog = "Create a new notification filter";
  final String editTitleDialog = "Edit an existing rule";

  final textEditingController = TextEditingController();

  List<NotificationFilter> list;
  NotificationFilter item;

  bool isEditMode = false;

  FilterRuleDialogState(
      List<NotificationFilter> list, NotificationFilter item) {
    this.list = list;
    this.item = item;
    String value = item == null ? "" : item.filterName;
    textEditingController.text = value;

    //if notification filter is not null then widget is for an editing
    this.isEditMode = item != null ? true : false;
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
                this.isEditMode
                    ? this.editTitleDialog
                    : this.createTitleDialog,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                //filter rule name visible on screen
                controller: textEditingController,
                //initialValue:  this.item == null ? "" : this,
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
              DropdownButton<ForwardingMode>(
                  value: isEditMode ? item.forwardingMode : ForwardingMode.Accepting,
                  //icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (ForwardingMode newValue) {
                    setState(() {
                      item.forwardingMode = newValue;
                    });
                  },
                  items: [
                    DropdownMenuItem<ForwardingMode>(
                        value: ForwardingMode.Accepting,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.thumb_up, color: Colors.green),
                            Text('Accepting'),
                          ],
                        )),
                    DropdownMenuItem<ForwardingMode>(
                        value: ForwardingMode.Rejecting,
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
                    if(this.isEditMode) {
                      item.filterName = this.textEditingController.text;
                    } else {
                      //if not in edit mode - create a new rule
                      NotificationFilter forwardingRule = NotificationFilter();
                      forwardingRule.filterName = textEditingController.text;
                      list.add(forwardingRule);
                    }
                    Navigator.of(context).pop(); // To close the dialog
                  },
                  child: Text(this.isEditMode ? "SAVE" : "CREATE"),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
