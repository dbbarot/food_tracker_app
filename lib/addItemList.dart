import 'package:flutter/material.dart';
import 'package:food_tracker_app/authentication.dart';
import 'package:food_tracker_app/addItem.dart';
import 'package:food_tracker_app/addItemDetail.dart';
import 'package:food_tracker_app/db_helper.dart';
import 'package:food_tracker_app/expiredProducts.dart';
import 'package:food_tracker_app/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class AddItemList extends StatefulWidget {
  AddItemList({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _AddItemListState();
}

class _AddItemListState extends State<AddItemList> {
  DbHelper dbHelper = DbHelper();
  List<AddItem> addItemList;
  int count = 0;
  DateTime cDate;

  @override
  void initState() {
    super.initState();
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    this.cDate = DateTime.now();
    if (addItemList == null) {
      addItemList = List<AddItem>();
      updateListResult();
    }
    _checkDate();
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(
          'Items List',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          new FlatButton(
              child: new Text('Logout',
                  style: new TextStyle(fontSize: 17.0, color: Colors.black)),
              onPressed: signOut)
        ],
      ),
      body: getAddItemListResult(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(AddItem('', '', ''), 'Add Item');
        },
        icon: Icon(Icons.add),
        label: Text('Add Item'),
        foregroundColor: Colors.black,
        tooltip: 'Add Item',
        //label: Text('Add Item'),
      ),
    );
  }

  ListView getAddItemListResult() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        String dd = Val.GetExpiryStr(this.addItemList[position].expirationDate);
        String dl = (dd != "1") ? " days left" : " day left";
        return Card(
          color: Colors.orange,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: (Val.GetExpiryStr(
                          this.addItemList[position].expirationDate) !=
                      "0")
                  ? Colors.blue
                  : Colors.red,
              child: Text(getQuantity(this.addItemList[position].quantity),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this.addItemList[position].productName,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle:
            Text(
                Val.GetExpiryStr(this.addItemList[position].expirationDate) +
                    dl +
                    '\nExp:' +
                    DateUtils.convertToDateFull(
                        this.addItemList[position].expirationDate)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.black,
                  ),
                  onTap: () {
                    _delete(context, addItemList[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              debugPrint('ListTile Tapped');
              navigateToDetail(this.addItemList[position], 'Edit AddItem');
            },
          ),
        );
      },
    );
  }

  getQuantity(String quantity) {
    return quantity.toString();
  }

  void _delete(BuildContext context, AddItem addItem) async {
    int result = await dbHelper.deleteAddItem(addItem.id);
    if (result != 0) {
      _showSnackBar(context, 'Item Deleted Successfully');
      updateListResult();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(AddItem addItem, String productName) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddItemDetail(addItem, productName);
    }));

    if (result == true) {
      updateListResult();
    }
  }

  void updateListResult() {
    final Future<Database> dbFuture = dbHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<AddItem>> addItemListFuture = dbHelper.getAddItemList();
      addItemListFuture.then((addItemList) {
        setState(() {
          this.addItemList = addItemList;
          this.count = addItemList.length;
        });
      });
    });
  }

  void _checkDate() {
    const secs = const Duration(seconds: 10);
    print('hey there');
    new Timer.periodic(secs, (Timer t) {
      DateTime nw = DateTime.now();
      if (cDate.day != nw.day ||
          cDate.month != nw.month ||
          cDate.year != nw.year) {
        updateListResult();
        cDate = DateTime.now();
      }
    });
  }
}
