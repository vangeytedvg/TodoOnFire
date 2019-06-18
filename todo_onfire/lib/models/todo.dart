/*
  Represents a todo item as a data class
  DVG 
  June 18, 2019
*/
class TodoItem {
  int _docId;
  String _title;
  String _details;
  String _createdDate;
  String _closedDate;
  int _ownerId;
  int _creatorId;
  int _priorityLevel;

  TodoItem(this._title, this._details, this._createdDate, this._closedDate,
      this._ownerId, this._creatorId, this._priorityLevel);
  TodoItem.withId(this._docId, this._title, this._details, this._createdDate,
      this._closedDate, this._ownerId, this._creatorId, this._priorityLevel);

  int get docId => this._docId;
  set docId(int docId) {
    _docId = docId;
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

  int get ownerId => _ownerId;
  set ownerId(int ownerId) {
    _ownerId = ownerId;
  }

  int get creatorId => _creatorId;
  set creatorId(int creatorId) {
    _creatorId = creatorId;
  }

  int get priorityLevel => _priorityLevel;
  set priorityLevel(int priorityLevel) {
    _priorityLevel = priorityLevel;
  }
}
