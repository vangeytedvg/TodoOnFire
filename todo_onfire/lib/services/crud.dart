/*
  Takes care of the database operations
  Modified June 17, 2019
  DVG
  Original source : http://tphangout.com/flutter-firestore-crud-updating-deleting-data/
*/

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';

class CrudMethods {
  bool isLoggedIn() {
    // this checks for currently logged user
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  // Insert record in the Firebase store
  Future<void> addData(carData) async {
    print(carData);
    if (isLoggedIn()) {
      await Firestore.instance.collection('testscrud').add(carData).catchError((e) {
        print(e);
      });
    } else {
      print("Not logged in");
    }
  }

  // Retrieve records from the Firebase store
  getData(String uId) async {
    // In the next sample, the name testcrud is the name of the 'table' in firebase.
    // But in firebase it is called a document....
    return await Firestore.instance
        .collection('testscrud')
        .where('user_id', isEqualTo: uId)
        .getDocuments()
        .catchError((e) {});
  }

  getProfileData(String uId)  {
    return Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: uId)
        .getDocuments();
  }

  updateStatus(selectedDoc, newstate) async {
    // Update the status flag of a todo item
    return await Firestore.instance
        .collection('testscrud')
        .document(selectedDoc)
        .updateData(newstate)
        .catchError((e) {
      print(e);
    });
  }

  // Update the data
  updateData(selectedDoc, newValues) async {
    return await Firestore.instance
        .collection('testscrud')
        .document(selectedDoc)
        .updateData(newValues)
        .catchError((e) {
      print(e);
    });
  }

  deleteData(docId) async {
    return await Firestore.instance
        .collection('testscrud')
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}
