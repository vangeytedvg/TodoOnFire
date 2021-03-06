/*
  Represents a todo item as a data class
  DVG 
  June 18, 2019
*/
class TodoItem {
  
  String _docId;
  String _title;
  String _details;
  String _createdDate;
  String _closedDate;
  String _ownerId;
  String _creatorId;
  String _priorityLevel;

  // Constructors
  TodoItem(this._title, this._details, this._createdDate, this._closedDate,
      this._ownerId, this._creatorId, this._priorityLevel);
  TodoItem.withId(this._docId, this._title, this._details, this._createdDate,
      this._closedDate, this._ownerId, this._creatorId, this._priorityLevel);

  // Now I create a map of this data, so FireBase will be able 
  // to use it (I hope)
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic> ();
    // Avoid error in case an id is not provided (for updates eg)
    if (_docId != null) {
      map['docId'] = _docId; 
    }

    map['title'] = this._title;
    map['details'] = this._details;
    map['createdDate'] = this._createdDate;
    map['closedDate'] = this._closedDate;
    map['ownerId'] = this._ownerId;
    map['creatorId'] = this._creatorId;
    map['priorityLevel'] = this._priorityLevel;

    return map;
  }

  // Named constructor convert a map to a normal todi item
  TodoItem.fromMap(Map<String, dynamic> map) {
    this._docId = map['docId'];
    this._title = map['title'];
    this._details = map['details'];
    this._createdDate = map['createdDate'];
    this._closedDate = map['closedDate'];
    this._ownerId = map['ownerId'];
    this._creatorId = map['creatorId'];
    this._priorityLevel = map['priorityLevel'];
  }

  /* Getter and setter section */
  
  String get docId => this._docId;
  set docId(String docId) {
    if (docId != null) {
      _docId = docId;
    }
  }

  String get title => _title;
  set title(String title) {
    _title = title;
  }

  String get details => _details;
  set details(String details) {
    _details = details;
  }

  String get createdDate => _createdDate;
  set createdDate(String createdDate) {
    _createdDate = createdDate;
  }

  String get closedDate => _closedDate;
  set closedDate(String closedDate) {
    _closedDate = closedDate;
  }

  String get ownerId => _ownerId;
  set ownerId(String ownerId) {
    _ownerId = ownerId;
  }

  String get creatorId => _creatorId;
  set creatorId(String creatorId) {
    _creatorId = creatorId;
  }

  String get priorityLevel => _priorityLevel;
  set priorityLevel(String priorityLevel) {
    _priorityLevel = priorityLevel;
  }
}
