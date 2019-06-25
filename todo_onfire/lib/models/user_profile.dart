/*
  user_profile.dart
  Data class representing a user profile.
  Author : DVG
  Last modified June 23, 2019
*/

class UserProfile {
  String _docId;
  String _email;
  String _password;
  String _nickName;
  String _gender;
  String _birthDate;
  String _name;
  String _firstName;
  String _registeredDateTime;

  /*
    Constructors.
    Note the default constructor has no ID, this is in case
    of a new profile.  If ID is needed use UserProfile.withId!
  */
  UserProfile(this._email, this._password, this._nickName, this._gender,
      this._birthDate, this._name, this._firstName, this._registeredDateTime);
  UserProfile.withId(
      this._docId,
      this._email,
      this._password,
      this._nickName,
      this._gender,
      this._birthDate,
      this._name,
      this._firstName,
      this._registeredDateTime);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    // Avoid error in case an id is not provided (for updates eg)
    if (_docId != null) {
      map['docId'] = _docId;
    }

    map['email'] = this._email;
    map['password'] = this._password;
    map['nickname'] = this._nickName;
    map['gender'] = this._gender;
    map['birthdate'] = this._birthDate;
    map['name'] = this._name;
    map['firstname'] = this._firstName;
    map['registereddatetime'] = this._registeredDateTime;
  }

  UserProfile.fromMap(Map<String, dynamic> map) {
    this._docId = map['docId'];
    this._email = map['email'];
    this._password = map['password'];
    this._nickName = map['nickname'];
  }
}
