import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_onfire/services/track.dart';
import 'package:provider/provider.dart';
import '../services/track.dart';
import '../services/crud.dart';
import '../components/imagewidgets.dart';
import '../components/buttons.dart';

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

  void _loginUser() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: this.email, password: this.password)
          .then((signedInUser) {
        Provider.of<UserTracker>(context).logInUser();
        Provider.of<UserTracker>(context).setUid(signedInUser.uid);
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
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: const EdgeInsets.all(18.0),
            child: AnimatedLoginImage(),),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "Email",
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0))),
                validator: (val) => !val.contains('@') ? "Invalid email!" : null,
                onSaved: (value) {
                  this.email = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextFormField(
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
            // Custon button (see buttons.dart)
            RoundedRaisedButton(
              onPushButton: () {
                _loginUser();
              },
            )
            /*RaisedButton(
                textColor: Colors.white,
                child: Text('Login'),
                color: Colors.blue,
                 shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                onPressed: _loginUser)*/
          ],
        ),
      ),
    );
  }
}
