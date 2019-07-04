/*
  Author DVG June 20, 2019 0:34am

  This class holds the login state of the user. It allows
  fast lookup via the Provider state manager.  
*/

import 'package:flutter/material.dart';

class UserTracker with ChangeNotifier {
  String _uid;
  String _email;
  String _userNickName;
  bool _isLoggedIn = false;

  // Ctors (one without id, and another with an id)
  // Had to do this during experiment with Provider.  
  // These at are called name construcor.  So you could
  // create an instance like eg UserTracker t = new UserTracker.withId()
  UserTracker.empty();
  UserTracker(this._isLoggedIn);
  UserTracker.withId(this._uid);

  getUid() => _uid;
  setUid(String uid) => _uid = uid;

  getEmail() => _email;
  setEmail(String email) => _email = email;

  getUserNickName() => _userNickName;

  // Check if the current user is logged into Firebase
  bool isUserLoggedIn() {
    return this._isLoggedIn;
  }

  // After logging in to Firebase, a call to this method
  // must be made to signal listeners.
  void logInUser() {
    this._isLoggedIn = true;
    notifyListeners();
  }

  // Same here when the user logs off
  void logOffUser() {
    this._isLoggedIn = false;
    notifyListeners();
  }
}
