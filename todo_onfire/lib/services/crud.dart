/*
  Takes care of the database operations
  Modified June 17, 2019
  DVG
  Original source : http://tphangout.com/flutter-firestore-crud-updating-deleting-data/
*/

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import '../models/todo.dart';

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
      Firestore.instance.collection('testscrud').add(carData).catchError((e) {
        print(e);
      });
    } else {
      print("Not logged in");
    }
  }

  // Retrieve records from the Firebase store
  getData() async {
    // In the next sample, the name testcrud is the name of the 'table' in firebase.
    // But in firebase it is called a document....
    return await Firestore.instance.collection('testscrud').getDocuments().catchError((e) {});
  }

  updateStatus(selectedDoc, newstate) async {
    // Update the status flag of a todo item
    Firestore.instance
      .collection('testscrud')
      .document(selectedDoc)
      .updateData(newstate)
      .catchError((e) {
        print(e);
      });
  }

  // Update the data
  updateData(selectedDoc, newValues) async {
    // I suppose we don't need to be async here, we are not waiting
    // for updates here, so...
    Firestore.instance
        .collection('testscrud')
        .document(selectedDoc)
        .updateData(newValues)
        .catchError((e) {
      print(e);
    });
  }

  deleteData(docId) {
    Firestore.instance
        .collection('testscrud')
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}
