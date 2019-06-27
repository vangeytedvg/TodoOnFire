import 'package:cloud_firestore/cloud_firestore.dart';
 import '../models/user_profile.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
 
class UserManagement {
  storeNewUser(UserProfile user, context) {
    Firestore.instance.collection('/users').add({
      'uid': user.docId,
      'name': user.name,
      'firstname': user.firstName,
      'email': user.email,
      'password': user.password,
      'nickname': user.nickName,
      'birthdate': user.birthDate,
      'gender': user.gender,
      'registereddatetime': DateTime.now().toString()
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/landingpage');
    }).catchError((e) {
      print(e);
    });
  }
}