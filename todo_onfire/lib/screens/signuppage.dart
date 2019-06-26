import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_onfire/models/user_profile.dart';
import 'package:todo_onfire/services/track.dart';
import 'package:provider/provider.dart';
import '../services/track.dart';
import '../services/crud.dart';
import '../components/imagewidgets.dart';
import '../components/buttons.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String activeUser;
  UserProfile userProfile = UserProfile("", "", "", "", "", "", "", "");
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
                            val.isEmpty ? "Name cannot be empty" : null,
                        onSaved: (value) {
                          this.email = value;
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
                          onChange: (String label, int index) =>
                              print("Label: $label, index: $index"),
                          onSelected: (String label) => print(label),
                        ),
                      ),
                    ),

  
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
                          this.email = value;
                        },
                      ),
                    ),

                    /*** Nickname */
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

                    /*** Email */
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

                    /*** Password */
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
                    // Custon button (see buttons.dart), here we can now use
                    // a custom event, in this case onPushButton.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RoundedRaisedButton(
                            label: Text("Login"),
                            buttonColor: Colors.blue,
                            fontColor: Colors.white,
                            onPushButton: () {
                              _loginUser();
                            },
                          ),
                        ),
                        RoundedRaisedButton(
                          label: Text("Sign up"),
                          buttonColor: Colors.yellow[200],
                          fontColor: Colors.black,
                          onPushButton: () {
                            Navigator.of(context).pushNamed('/signup');
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
