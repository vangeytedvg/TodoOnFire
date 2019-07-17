import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_onfire/services/track.dart';
import 'package:provider/provider.dart';
import 'package:todo_onfire/services/usermanagement.dart';
import '../services/track.dart';

class Experiments extends StatefulWidget {
  @override
  _ExperimentsState createState() => _ExperimentsState();
}

class _ExperimentsState extends State<Experiments> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Experimental Zone"),
        centerTitle: false,
      ),
      body: new Container(
        color: Colors.deepOrange,
        child: Center(child: Text("This is Area 51!", style: TextStyle(fontSize: 25.0),),
      ),

    ));
  }
}