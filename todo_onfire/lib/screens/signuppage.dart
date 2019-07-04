/*
  signuppage.dart
  Author DVG
  June 28, 2019
  Status : stable
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_onfire/models/user_profile.dart';
import 'package:todo_onfire/services/track.dart';
import 'package:provider/provider.dart';
import '../services/track.dart';
import '../services/crud.dart';
import '../services/usermanagement.dart';
import '../components/buttons.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  DateTime date;
  String email;
  String password;
  String activeUser;
  UserProfile userProfile = UserProfile("", "", "", "", "", "", "", "");
  CrudMethods crudObj = new CrudMethods();

  /*
    Create the user in the firebase authorization store and
    also in the app specific users table.
  */
  void _createUser() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: this.userProfile.email, password: this.password)
          .then((signedInUser) {
            print(signedInUser.getIdToken());
            print(signedInUser.uid);
            UserManagement um = new UserManagement();
            this.userProfile.docId = signedInUser.uid;
            um.storeNewUser(this.userProfile, context);
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
    AssetImage assetImage = AssetImage('images/connection.png');
    Image image = Image(
      image: assetImage,
      height: 150.0,
      width: 150.0,
    );
    return new Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        //backgroundColor: Colors.orange[900],
        title: Text('Signup'),
        centerTitle: true,
      ),
      body: new Container(
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: image,
                    ),

                    /*** NAME ***/
                    Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: "Lastname",
                              hintText: 'Your Lastname',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0))),
                          validator: (val) =>
                              val.isEmpty ? "Lastname cannot be empty" : null,
                          onSaved: (value) {
                            this.userProfile.name = value;
                          },
                        )),

                    /*** First name ***/
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "First name",
                            hintText: 'Your firstname',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0))),
                        validator: (val) =>
                            val.isEmpty ? "Firstame cannot be empty" : null,
                        onSaved: (value) {
                          this.userProfile.firstName = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: const Text("Gender:"),
                    ),

                    /*** Gender */
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(
                        child: RadioButtonGroup(
                          orientation: GroupedButtonsOrientation.VERTICAL,
                          labels: <String>["Male", "Female"],
                          onSelected: (String label) =>
                              this.userProfile.gender = label,
                        ),
                      ),
                    ),

                    /*** Email address ***/
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "Email",
                            hintText: 'someone@somewhere.com',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0))),
                        validator: (val) =>
                            !val.contains('@') ? "Invalid email!" : null,
                        onSaved: (value) {
                          this.userProfile.email = value;
                          this.email = value;
                        },
                      ),
                    ),

                    /*** Password */
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
                          this.userProfile.password = value;
                          this.password = value;
                        },
                        obscureText: true,
                      ),
                    ),

                    /*** Nickname */
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "Nickname",
                            hintText: 'Enter your nickname',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0))),
                        validator: (val) =>
                            val.isEmpty ? "Nickname needed" : null,
                        onSaved: (value) {
                          this.userProfile.nickName = value;
                        },
                      ),
                    ),

                    /*** Birthdate */
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: DateTimePickerFormField(
                        inputType: InputType.date,
                        format: DateFormat('yyyy-MM-dd'),
                        editable: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                            labelText: 'Birthdate',
                            hasFloatingPlaceholder: true),
                        onChanged: (dt) {
                          setState(() {
                           userProfile.birthDate = dt.toString(); 
                          });
                        } ,
                      ),
                    ),

                    // Custon button (see buttons.dart), here we can now use
                    // a custom event, in this case onPushButton.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RoundedRaisedButton(
                            label: Text("I want in!"),
                            buttonColor: Colors.blue,
                            fontColor: Colors.white,
                            onPushButton: () {
                              final form = _formKey.currentState;
                              if (form.validate()) {
                                // First create our user in the separate
                                // users table.  This is not the actual authorisation
                                // table, but is used by the app for other things.
                                form.save();
                                _createUser();
                                Navigator.of(context).pushNamed('/landingpage');
                              }
                            },
                          ),
                        ),
                        RoundedRaisedButton(
                          label: Text("Back"),
                          buttonColor: Colors.red,
                          fontColor: Colors.black,
                          onPushButton: () {
                            Navigator.of(context).pushNamed('/landingpage');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
