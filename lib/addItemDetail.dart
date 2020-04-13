import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:food_tracker_app/addItem.dart';
import 'package:food_tracker_app/db_helper.dart';
import 'package:food_tracker_app/utils.dart';
import 'package:intl/intl.dart';

class AddItemDetail extends StatefulWidget {
  final String appBarTitle;
  final AddItem addItem;
  AddItemDetail(this.addItem, this.appBarTitle) : super();

  @override
  State<StatefulWidget> createState() =>
      new _AddItemDetailState(this.addItem, this.appBarTitle);
}

class _AddItemDetailState extends State<AddItemDetail> {
  DbHelper helper = DbHelper();
  //DateTime datePicker = DateTime(null);
  String appBarTitle;
  AddItem addItem;
  final int daysAhead = 5475; // no of days in future
  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController expirationDateController = TextEditingController();

  _AddItemDetailState(this.addItem, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    productNameController.text = addItem.productName;
    quantityController.text = addItem.quantity;
    descriptionController.text = addItem.description;
    expirationDateController.text = addItem.expirationDate;

    return WillPopScope(
      onWillPop: () {
        // Write some code to control things, when user press Back navigation button in device navigationBar
        goToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            appBarTitle,
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {
                // Write some code to control things, when user press back button in AppBar
                goToLastScreen();
              }),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              // First Field
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: productNameController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('Something changed in Title Text Field');
                    updateProductName();
                  },
                  decoration: InputDecoration(
                      labelText: 'Product',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              //Second Field
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: quantityController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('Something changed in Title Text Field');
                    updateQuantity();
                  },
                  decoration: InputDecoration(
                      labelText: 'Quantity',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              // Third Field
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: descriptionController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('Something changed in Title Text Field');
                    updateDescription();
                  },
                  decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              // Fpourth Field
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: expirationDateController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('Something changed in Title Text Field');
                    updateExpirationDate();
                  },
                  decoration: InputDecoration(
                      labelText: 'Expired Date',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              // Fifth Field
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FloatingActionButton.extended(
                        heroTag: 'Hello2',
                        icon: Icon(
                          Icons.update,
                          color: Colors.black,
                        ),
                        label: Text(
                          'Update',
                          style: TextStyle(color: Colors.black),
                        ),
                        splashColor: Colors.black,
                        onPressed: () {
                          setState(() {
                            debugPrint('Update Button Clicked');
                            _update();
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 5.0,
                    ),
                    Expanded(
                      child: FloatingActionButton.extended(
                        heroTag: 'Hello3',
                        icon: Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                        label: Text(
                          'Delete',
                          style: TextStyle(color: Colors.black),
                        ),
                        splashColor: Colors.black,
                        onPressed: () {
                          setState(() {
                            debugPrint('Delete Button Clicked');
                            _delete();
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void goToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateProductName() {
    addItem.productName = productNameController.text;
  }

  void updateQuantity() {
    addItem.quantity = quantityController.text;
  }

  void updateDescription() {
    addItem.description = descriptionController.text;
  }

  void updateExpirationDate() {
    addItem.expirationDate = expirationDateController.text;
  }

  void _update() async {
    goToLastScreen();

    int result;
    if (addItem.id != null) {
      // Case 1: Update operation
      result = await helper.updateAddItem(addItem);
    } else {
      // Case 2: Insert Operation
      print('This is');
      print(addItem.id);
      result = await helper.insertAddItem(addItem);
      print(result);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'addItem updated Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem updating addItem');
    }
  }

  void _delete() async {
    goToLastScreen();

    // Case 1: If user is trying to delete the NEW addItem i.e. he has come to
    // the detail page by pressing the FAB of addItemList page.
    if (addItem.id == null) {
      _showAlertDialog('Status', 'No addItem was deleted');
      return;
    }

    // Case 2: User is trying to delete the old addItem that already has a valid ID.
    int result = await helper.deleteAddItem(addItem.id);
    if (result != 0) {
      _showAlertDialog('Status', 'addItem Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting addItem');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = DateUtils.convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= now.year && initialDate.isAfter(now)
        ? initialDate
        : now);

    DatePicker.showDatePicker(context, showTitleActions: true,
        onConfirm: (date) {
      setState(() {
        DateTime dt = date;
        String r = DateUtils.ftDateAsStr(dt);

        expirationDateController.text = r;
      });
    }, currentTime: initialDate);
  }
}
