import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_onfire/services/track.dart';
import 'package:provider/provider.dart';
import '../services/track.dart';
import '../services/crud.dart';
import '../components/imagewidgets.dart';
import '../components/buttons.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String activeUser;
  CrudMethods crudObj = new CrudMethods();

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

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
    return new Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        //backgroundColor: Colors.orange[900],
        leading: Center(
            child: AnimatedIcon(
                icon: AnimatedIcons.list_view, progress: controller)),
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
                      child: AnimatedLoginImage(),
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
                            this.email = value;
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
                            !val.contains('@') ? "Invalid email!" : null,
                        onSaved: (value) {
                          this.email = value;
                        },
                      ),
                    ),
                    /*** Gender */
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
                      children: <Widget>[
                        RoundedRaisedButton(
                          label: Text("Login"),
                          buttonColor: Colors.blue,
                          fontColor: Colors.white,
                          onPushButton: () {
                            _loginUser();
                          },
                        ),
                        RoundedRaisedButton(
                          label: Text("Sign up"),
                          buttonColor: Colors.yellow[200],
                          fontColor: Colors.black,
                          onPushButton: () {
                            controller.forward();
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
