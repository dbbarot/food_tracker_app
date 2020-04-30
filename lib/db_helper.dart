/*
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:food_tracker_app/addItem.dart';

class DbHelper {
  static DbHelper _dbHelper;
  static Database _db;

  String addItemTable = 'addItem_table';
  String colId = 'id';
  String colProductName = 'productName';
  String colQuantity = 'quantity';
  String colDescription = 'description';
  String colExpirationDate = 'expirationDate';

  DbHelper._createInstance(); // Named constructor to create instance of DbHelper

  factory DbHelper() {

    if (_dbHelper == null) {
      _dbHelper = DbHelper._createInstance(); // Only one Time Execution
    }
    return _dbHelper;
  }

  Future<Database> get database async {

    if (_db == null) {
      return await initializeDatabase();
    }
    return _db;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'addItems.db';
    var addItemsDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return addItemsDb;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $addItemTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colProductName TEXT, '
        ' $colQuantity TEXT,$colDescription TEXT, '
        ' $colExpirationDate TEXT)');
  }

  // Fetch Operation: Get all addItem objects from database
  Future<List<Map<String, dynamic>>> getAddItemMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $addItemTable order by $colExpiration ASC');
    var result = await db.query(addItemTable, orderBy: '$colExpirationDate ASC');
    return result;
  }

  // Retrieves specific is id.
  Future<List> getItem(int id) async {
    Database db = await this.database;
		var result = await db.rawQuery('SELECT * FROM $addItemTable WHERE $colId= ' + id.toString() + "");
   // var result = await db.query(addItemTable, orderBy: '$colExpirationDate ASC');
    return result;
  }

  //
  Future<List> getItemWithExpirationDate(String payload) async {
    List<String> p = payload.split('|');
    if(p.length == 2) {
      Database db = await this.database;
      var result = await db.rawQuery(
          'SELECT * FROM $addItemTable WHERE $colId = ' + p[0] + 'AND $colExpirationDate=' + p[1] + "");
      //   var result = await db.query(addItemTable, orderBy: '$colExpirationDate ASC');
      return result;
    }else
      return null;
  }
  // Insert Operation: Insert a addItem object to database
  Future<int> insertAddItem(AddItem addItem) async {
    Database db = await this.database;
    var result = await db.insert(addItemTable, addItem.toMap());
    return result;
  }

  // Update Operation: Update a addItem object and save it to database
  Future<int> updateAddItem(AddItem addItem) async {
    var db = await this.database;
    var result = await db.update(addItemTable, addItem.toMap(), where: '$colId = ?', whereArgs: [addItem.id]);
    return result;
  }

  Future<int> updateAddItemCompleted(AddItem addItem) async {
    var db = await this.database;
    var result = await db.update(addItemTable, addItem.toMap(), where: '$colId = ?', whereArgs: [addItem.id]);
    return result;
  }

  // Delete Operation: Delete a addItem object from database
  Future<int> deleteAddItem(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $addItemTable WHERE $colId = $id');
    return result;
  }

  // Get number of addItem objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $addItemTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'addItem List' [ List<addItem> ]
  Future<List<AddItem>> getAddItemList() async {

    var addItemMapList = await getAddItemMapList(); // Get 'Map List' from database
    int count = addItemMapList.length;         // Count the number of map entries in db table

    List<AddItem> addItemList = List<AddItem>();
    // For loop to create a 'addItem List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      addItemList.add(AddItem.fromMapObject(addItemMapList[i]));
    }

    return addItemList;
  }
  
}
*/
