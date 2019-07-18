import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_onfire/services/track.dart';
import 'package:todo_onfire/services/usermanagement.dart';

import '../components/buttons.dart';
import '../components/imagewidgets.dart';
import '../services/crud.dart';
import '../services/track.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email;
  String password;
  String activeUser;
  final _formKey = GlobalKey<FormState>();
  CrudMethods crudObj = new CrudMethods();
  UserManagement um;

  void _loginUser() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: this.email, password: this.password)
          .then((signedInUser) {
        // Signal that the user is logged in
        Provider.of<UserTracker>(context).logInUser();
        Provider.of<UserTracker>(context).setUid(signedInUser.uid);
        // Now get the details of this user
        Navigator.of(context).pushReplacementNamed('/homepage');
      }).catchError((e) {
        Scaffold.of(context).showSnackBar(
          new SnackBar(content: Text(e.toString())),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: AnimatedLoginImage(),
                ),
                /* Email */
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextFormField(
                    initialValue: "i@i.be",
                    decoration: InputDecoration(
                        labelText: "Email",
                        hintText: 'Enter your email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0))),
                    validator: (val) =>
                        !val.contains('@') ? "Invalid email!" : null,
                    onSaved: (value) {
                      this.email = value;
                    },
                  ),
                ),

                /* Password */
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextFormField(
                    initialValue: "denka123",
                    decoration: InputDecoration(
                        labelText: "Password",
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0))),
                    validator: (val) =>
                        val.length < 6 ? "Password is too short!" : null,
                    onSaved: (value) {
                      this.password = value;
                    },
                    obscureText: true,
                  ),
                ),
                /* controls */
                // Custon button (see buttons.dart), here we can now use
                // a custom event, in this case onPushButton.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: RoundedRaisedButton(
                        label: Text("Login"),
                        buttonColor: Colors.blue,
                        fontColor: Colors.white,
                        onPushButton: () {
                          _loginUser();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RoundedRaisedButton(
                        label: Text("Sign up"),
                        buttonColor: Colors.yellow[200],
                        fontColor: Colors.black,
                        onPushButton: () {
                          Navigator.of(context).pushNamed('/signup');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
