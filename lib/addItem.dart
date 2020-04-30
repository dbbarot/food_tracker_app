import 'package:firebase_database/firebase_database.dart';

class AddItem {
  String key;
  String _productName;
  String _quantity;
  String _description;
  String _expirationDate;
  int _userId;

  AddItem(this._productName, this._quantity, this._description, this._expirationDate);

  AddItem.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        _userId = snapshot.value["userId"],
        _productName = snapshot.value["productName"],
        _quantity = snapshot.value["quantity"],
        _description = snapshot.value["description"],
        _expirationDate = snapshot.value["expirationDate"];

  toJson() {
    return {
      "userId" : _userId,
      "productName": _productName,
      "quantity": _quantity,
      "description": _description,
      "expirationDate": _expirationDate
    };
  }
  AddItem.withId(this.key, this._productName, this._quantity, this._expirationDate, [this._description]);

  //String get key => key;

  String get productName => _productName;

  String get quantity => _quantity;

  String get description => _description;

  String get expirationDate => _expirationDate;

  set productName(String newProductName) {
    if (newProductName.length <= 255) {
      this._productName = newProductName;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  set expirationDate(String newExpirationDate) {
    this._expirationDate = newExpirationDate;
  }

  set quantity(String newQuantity) {
    this._quantity = newQuantity;
  }

  // Convert a Note object into a Map object
  /*Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (key != null) {
      map['key'] = key;
    }
    map['productName'] = _productName;
    map['quantity'] = _quantity;
    map['description'] = _description;
    map['expirationDate'] = _expirationDate;

    return map;}

  // Extract a Note object from a Map object
   AddItem.fromMapObject(Map<String, dynamic> map) {
    this.key = map['key'];
    this._productName = map['productName'];
    this._quantity = map['quantity'];
    this._description = map['description'];
    this._expirationDate = map['expirationDate'];
  }*/
}
