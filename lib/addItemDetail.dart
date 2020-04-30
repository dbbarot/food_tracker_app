import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:food_tracker_app/addItem.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_tracker_app/utils.dart';
import 'package:food_tracker_app/addItemList.dart';
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
  //DbHelper helper = DbHelper();
  //DateTime datePicker = DateTime(null);
  String appBarTitle;
  AddItem addItem;
  String userId;
  AddItemList addItemList;
  final int daysAhead = 5475; // no of days in future
  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController expirationDateController =
      MaskedTextController(mask: '2000-00-00');
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var currentUser = " ";
  _AddItemDetailState(this.addItem, this.appBarTitle){
    _auth.currentUser().then((user) {
      setState(() {
        currentUser = user.uid;
      });
        print(currentUser);
    }).catchError((e){

    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    productNameController.text = addItem.productName;
    quantityController.text = addItem.quantity;
    descriptionController.text = addItem.description;
    expirationDateController.text = addItem.expirationDate;

    return WillPopScope(
      // ignore: missing_return
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
          actions: <Widget>[
            new FlatButton(
                child: new Text('Save',
                    style: new TextStyle(fontSize: 17.0, color: Colors.black)),
                onPressed: (){
                  goToLastScreen();
                  /*_database
                      .reference()
                      .child(currentUser + '/addItem/')
                      .child(addItem.key)
                      .set(addItem.toJson());*/
                  updateAddItem(addItem);
                  _showAlertDialog('Status', addItem.productName + ' item Saved Successfully');
                }
            )
          ],
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {
                // Write some code to control things, when user press back button in AppBar
                goToLastScreen();
              }),
        ),
        body: Form(
          key: _formKey,
          autovalidate: true,
          child: SafeArea(
            top: false,
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: <Widget>[
                // First Field
                SizedBox(height: 8.0, width: 16.0,),
                TextFormField(
                  inputFormatters: [
                    WhitelistingTextInputFormatter(
                        RegExp("[a-zA-Z0-9 ]"))
                  ],
                  controller: productNameController,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  validator: (val) => Val.ValidateTitle(val),
                  /*onSaved: (value) {
                    debugPrint('Something changed in Title Text Field');
                    //updateProductName();
                  },*/
                  decoration: InputDecoration(
                    icon: const Icon(Icons.fastfood),
                      hintText: 'Enter the product name',
                      hintStyle: TextStyle(color:  Colors.green),
                      labelText: 'Product',
                      labelStyle: TextStyle(color : Colors.green),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
                //Second Field
                SizedBox(height: 8.0, width: 16.0,),
                TextFormField(
                  controller: quantityController,
                  style: textStyle,
                  validator: (val) => Val.ValidateTitle(val),
                  /*onSaved: (value) {
                    debugPrint('Something changed in Title Text Field');
                    updateQuantity();
                  },*/
                  decoration: InputDecoration(
                      icon: const Icon(Icons.confirmation_number),
                      hintText: 'Enter the Quantity',
                      hintStyle: TextStyle(color:  Colors.green),
                      labelText: 'Quantity',
                      labelStyle: TextStyle(color : Colors.green),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
                // Third Field
                SizedBox(height: 8.0, width: 16.0,),
                TextFormField(
                  controller: descriptionController,
                  style: textStyle,
                  validator: (val) => Val.ValidateTitle(val),
                  /*onSaved: (value) {
                    debugPrint('Something changed in Title Text Field');
                    updateDescription();
                  },*/
                  decoration: InputDecoration(
                      icon: const Icon(Icons.description),
                      hintText: 'Enter description ',
                      hintStyle: TextStyle(color:  Colors.green),
                      labelText: 'Description',
                      labelStyle: TextStyle(color : Colors.green),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
                // Fpourth Field
                SizedBox(height: 8.0, width: 16.0,),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: expirationDateController,
                        style: textStyle,
                        /*onSaved: (value) {
                          debugPrint('Something changed in Title Text Field');
                          updateExpirationDate();
                        },*/
                        decoration: InputDecoration(
                          icon: const Icon(Icons.calendar_today),
                          hintText: 'Enter Expiration Date',
                          hintStyle: TextStyle(color:  Colors.green),
                          labelText: 'Expired Date',
                          labelStyle: TextStyle(color : Colors.green),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        //keyboardType: TextInputType.number,
                        validator: (val) => DateUtils.isValidDate(val)
                            ? null
                            : 'Not a valid future date',
                      ),
                    ),
                    IconButton(
                      icon: new Icon(Icons.more_horiz),
                      tooltip: 'Choose date',
                      onPressed: (() {
                        _chooseDate(context, expirationDateController.text);
                      }),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            if(this._formKey.currentState.validate()) {
                              this._formKey.currentState.save();
                             // _update();
                              /*Navigator.pop(context, true);*/
                              addNewItem(productNameController.text.toString());
                              _showAlertDialog('Status', productNameController.text.toString() + '  added successfully');

                              //goToLastScreen();
                            }else{
                              this._formKey.currentState.save();
                              _showAlertDialog('Status', 'Some data is invalid. Please correct.');
                              //goToLastScreen();
                            }
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
                            if(this._formKey.currentState.validate()) {
                              this._formKey.currentState.save();
                              //_delete();
                            }else{
                              _showAlertDialog('Status', 'Some data is invalid. Please correct.');
                            }
                          });
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void goToLastScreen() {
    Navigator.pop(context, true);
  }



  addNewItem(String addItem) {
    goToLastScreen();
    //addItem
    if (addItem.length > 0) {
      AddItem addItem = new AddItem(productNameController.text.toString(), quantityController.text.toString(),
                                      descriptionController.text.toString(), expirationDateController.text.toString());
      print(currentUser);
      _database.reference().child(currentUser +  '/addItem/').push().set(addItem.toJson());
    }
  }

  updateAddItem(AddItem addItem) {
    //Toggle completed
    /*todo.completed = !todo.completed;*/
    if (addItem != null) {
      _database
          .reference()
          .child(currentUser + '/addItem/')
          .child(addItem.key)
          .set(addItem.toJson());
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  Future<Null> _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = DateUtils.convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= now.year && initialDate.isAfter(now)
        ? initialDate
        : now);

    DatePicker.showDatePicker(context, showTitleActions: true,
        onConfirm: (date) {
      print('At here Date');
      setState(() {
        DateTime dt = date;
        String r = DateUtils.ftDateAsStr(dt);
        print(expirationDateController.text.toString());
        expirationDateController.text = r;
      });
    }, currentTime: initialDate);
  }

  void _submitForm() {

    final FormState form = _formKey.currentState;

    if (!form.validate()) {

     // showMessage('Some data is invalid. Please correct.');

    } else {

     // _update();

    }

  }

  void _initCtrls(){
    productNameController.text = widget.addItem.productName != null ? widget.addItem.productName : "";
    quantityController.text = widget.addItem.quantity != null ? widget.addItem.quantity : "";
    descriptionController.text = widget.addItem.description != null ? widget.addItem.description : "";
    expirationDateController.text = widget.addItem.expirationDate != null ? widget.addItem.expirationDate : "";
  }

}
