import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food_tracker_app/authentication.dart';
import 'package:food_tracker_app/addItem.dart';
import 'package:food_tracker_app/addItemDetail.dart';
//import 'package:food_tracker_app/sqflite/db_helper.dart';
import 'package:food_tracker_app/expiredProducts.dart';
import 'package:food_tracker_app/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/src/widgets/scroll_controller.dart';
import 'dart:async';

class AddItemList extends StatefulWidget {
  AddItemList({Key key, this.auth, this.userId, this.logoutCallback, String payload})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  //final FirebaseUser userId;
  @override
  State<StatefulWidget> createState() => new _AddItemListState();
}

class _AddItemListState extends State<AddItemList> {
  // DbHelper dbHelper = DbHelper();
  List<AddItem> addItemList;
  int count = 0;
  DateTime cDate;
  Query _addItemQuery;
  var currentUser = "unknown";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ScrollController _listViewScrollController = new ScrollController();
  double _itemExtent = 50.0;

  _AddItemListState() {
    _auth.currentUser().then((user) {
      setState(() {
        currentUser = user.uid;
        /*if (addItemList == null) {
          addItemList = List<AddItem>();
          updateListResult();
        }*/
      });
      _addItemQuery = _database
          .reference()
          .child(currentUser + '/addItem/')
          .orderByChild('expirationDate');
      addItemList = new List();
      print(currentUser);
      _onTodoAddedSubscription =
          _addItemQuery.onChildAdded.listen(onEntryAdded);
      _onTodoChangedSubscription =
          _addItemQuery.onChildChanged.listen(onEntryChanged);
      _checkDate();

      //_checkDate();
      //updateListResult();
      print('Something got changed');
      print(_onTodoChangedSubscription);
    }).catchError((e) {
      print('unable to find the correct user');
    });
  }

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

   _scheduleNotification() async {
    var scheduledNotificationDateTime =
    DateTime.now().add(Duration(seconds: 5));
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
        icon: 'secondary_icon',
        sound: RawResourceAndroidNotificationSound('slow_spring_board'),
        largeIcon: DrawableResourceAndroidBitmap('sample_large_icon'),
        vibrationPattern: vibrationPattern,
        enableLights: true,
        color: const Color.fromARGB(255, 255, 0, 0),
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500);
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails(sound: 'slow_spring_board.aiff');
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }
  @override
  void initState() {
    super.initState();
    //updateListResult();
    /*addItemList = new List();
    print(currentUser);
    _addItemQuery = _database.reference().child('addItem').orderByChild('expirationDate');
    print(currentUser);
    _onTodoAddedSubscription = _addItemQuery.onChildAdded.listen(onEntryAdded);
    _onTodoChangedSubscription =
        _addItemQuery.onChildChanged.listen(onEntryChanged);
    print('Something got changed');
    print(_onTodoChangedSubscription);*/
    /*FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();*/
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    final settingsAndroid =
    AndroidInitializationSettings('final_food_tracker_logo');
    /*var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);*/
    flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(settingsAndroid, null));
    _scheduleNotification();
  }

  @override
  void dispose() {
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    super.dispose();
  }

  onEntryAdded(Event event) {
    setState(() {
      addItemList.add(AddItem.fromSnapshot(event.snapshot));
      /*updateListResult();
      _checkDate();*/
    });
    //_scrollToTop();
  }

  onEntryChanged(Event event) {
    var oldEntry = addItemList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      addItemList[addItemList.indexOf(oldEntry)] =
          AddItem.fromSnapshot(event.snapshot);
      /*updateListResult();
      _checkDate();*/
    });
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
          navigateToDetail(AddItem('', '', '', ''), 'Add Item');
        },
        icon: Icon(Icons.add),
        label: Text('Add Item'),
        foregroundColor: Colors.black,
        tooltip: 'Add Item',
        //label: Text('Add Item'),
      ),
    );
  }

  Widget getAddItemListResult() {
    if (addItemList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          controller: _listViewScrollController,
          itemCount: addItemList.length,
          itemBuilder: (BuildContext context, int index) {
            String addItemId = this.addItemList[index].key;
            String productName = this.addItemList[index].productName;
            String quantity = this.addItemList[index].quantity;
            String description = this.addItemList[index].description;
            String expirationDate = this.addItemList[index].expirationDate;
            /*bool completed = addItemList[index].completed;
            String userId = addItemList[index].userId;*/
            String dd =
                Val.GetExpiryStr(this.addItemList[index].expirationDate);
            String dl = (dd != "") ? " days left" : " day left";
            return Card(
              color: Colors.lightGreen,
              elevation: 2.0,
              child:Dismissible(
                  key: Key(addItemId),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) async {
                    delete(addItemId, index);
                    //updateAddItem(addIt);
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: (Val.GetExpiryStr(expirationDate) != "0")
                          ? Colors.blue
                          : Colors.red,
                      child: Text(getQuantity(quantity),
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                    ),
                    title: Text(productName,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(Val.GetExpiryStr(expirationDate) +
                        dl +
                        '\nExp:' +
                        DateUtils.convertToDateFull(expirationDate)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          child: Icon(
                            Icons.delete,
                            color: Colors.black,
                          ),
                          onTap: () {
                            delete(addItemList[index].key, index);
                            _showSnackBar(
                                context,
                                addItemList[index].productName +
                                    ' deleted successfully');
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      debugPrint('ListTile Tapped');
                      print(this.addItemList[index]);
                      print(addItemList[index]);
                      navigateToDetail(this.addItemList[index], 'Edit AddItem');
                    },
                  ),
                ),
            );
          });
    } else {
      return Center(
          child: Text(
        "Welcome. Your list is empty",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),
      ));
    }
  }


  getQuantity(String quantity) {
    return quantity.toString();
  }


  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  delete(String addItemId, int index) {
    _database
        .reference()
        .child(currentUser + '/addItem/')
        .child(addItemId)
        .remove()
        .then((_) {
      print("Delete $addItemId successful");
      setState(() {
        addItemList.removeAt(index);
        updateListResult();
      });
    });
  }

  void navigateToDetail(AddItem addItem, String productName) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddItemDetail(addItem, productName);
    }));

    // ignore: unrelated_type_equality_checks
    if (result == true) {
      updateListResult();
    }
  }

  updateAddItem(AddItem addItem) {
    //Toggle completed
    /*todo.completed = !todo.completed;*/
    if (addItem != null) {
      _database
          .reference()
          .child("addItem")
          .child(addItem.key)
          .set(addItem.toJson());
    }
  }

  void updateListResult() {
    /*addItemList = new List();
    _addItemQuery = _database
        .reference()
        .child(currentUser + '/addItem/')
        .orderByChild('expirationDate');
    _onTodoAddedSubscription = _addItemQuery.onChildAdded.listen(onEntryAdded);
    print(currentUser);
    _onTodoChangedSubscription =
        _addItemQuery.onChildChanged.listen(onEntryChanged);*/
    List<AddItem> tempList = new List();
    //addItemList = new List();
    _database.reference().child(currentUser + '/addItem/').orderByChild('expirationDate').once().then((ds){
      print(ds.value);
      //var tempList = [];
      ds.value.forEach((k,v){
        print(k);
        print(v);
        tempList.add(v);
      });
      print(addItemList);
      print(tempList);
      addItemList.clear();
      setState(() {
        addItemList = tempList;
      });
    }).catchError((e){
      print('Failed to get the addItemList' + e.toString());
    });
    setState(() {
      _checkDate();
    });
    //
  }

  void _checkDate() {
    const secs = const Duration(seconds: 5);
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

  _scrollToTop() {
    _listViewScrollController.animateTo(
      addItemList.length * _itemExtent,
      duration: const Duration(microseconds: 1),
      curve: new ElasticInCurve(0.01),
    );
  }
}
