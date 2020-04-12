class AddItem{
  int _id;
  String _productName;
  String _quantity;
  String _description;
  String _expirationDate;

  AddItem(this._productName, this._quantity,this._expirationDate, [this._description]);

  AddItem.withId(this._id, this._productName, this._quantity, this._expirationDate, [this._description]);

  int get id => _id;

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
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['productName'] = _productName;
    map['quantity'] = _quantity;
    map['description'] = _description;
    map['expirationDate'] = _expirationDate;

    return map;
  }

  // Extract a Note object from a Map object
  AddItem.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._productName = map['productName'];
    this._quantity = map['quantity'];
    this._description = map['description'];
    this._expirationDate = map['expirationDate'];
  }
}