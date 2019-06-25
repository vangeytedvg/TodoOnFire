/*
  signuppage.dart
  Allows new user to sign up for the Todo's on Fire app
  Author : DVG
  Modified : June 23, 2019
*/

import 'package:flutter/material.dart';
import '../services/usermanagement.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../services/track.dart';
import '../services/crud.dart';
import '../components/imagewidgets.dart';
import '../components/buttons.dart';
 
class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}
 
class _SignupPageState extends State<SignupPage> {
  String _email;
  String _password;
  
 
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Center(
      child: Container(
          padding: EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                  decoration: InputDecoration(hintText: 'Email'),
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  }),
              SizedBox(height: 15.0),
              TextField(
                  decoration: InputDecoration(hintText: 'Password'),
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  }),
              SizedBox(height: 20.0),
              RaisedButton(
                child: Text('Sign Up'),
                color: Colors.blue,
                textColor: Colors.white,
                elevation: 7.0,
                onPressed: () {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _email, password: _password)
                      .then((signedInUser) {
                    UserManagement().storeNewUser(signedInUser, context);
                  }).catchError((e) {
                    print(e);
                  });
                },
              ),
            ],
          )),
    ));
  }
}