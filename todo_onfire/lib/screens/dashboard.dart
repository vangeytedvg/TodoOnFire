/*
  DVG Technical reminder for this code
  testscrud is like the name of the table
  FirebaseCRUD is the database
  DVG June 17, 2019
  Made a lot of modifications, so the app starts to look and behave like
  a todo list (but then one on steroids).
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/crud.dart';
import '../models/todo.dart';

enum ConfirmAction { DELETE, CANCEL }
enum TodoState { DONE, NOTDONE }

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String carModel;
  String carColor;
  TodoItem todoItem;
  bool done = false;
  QuerySnapshot cars;
  CrudMethods crudObj = new CrudMethods();
  @override
  void initState() {
    crudObj.getData().then((results) {
      setState(() {
        cars = results;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.orange[900],
          title: Text('Dashboard'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                addDialog(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                crudObj.getData().then((results) {
                  setState(() {
                    cars = results;
                  });
                });
              },
            )
          ],
        ),
        body: _carList());
  }

  Widget _carList() {
    // The cars snapshot is reetrieved in the Widget Build method above

    return new Container(
      child: StreamBuilder(
        // This keeps track of changes in the DB itself.  Listeners....
        stream: Firestore.instance.collection('testscrud').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Workaround for the builder null error
          if (snapshot.hasError) return new Text('${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Center(child: new CircularProgressIndicator());
            default:
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                padding: EdgeInsets.all(5.0),
                itemBuilder: (context, i) {
                  todoItem = new TodoItem.withId(
                      snapshot.data.documents[i].documentID,
                      "",
                      "",
                      "",
                      "",
                      0,
                      0,
                      0);
                  done = snapshot.data.documents[i].data['status'];
                  return new Container(
                    child: Card(
                      elevation: 5.0,
                      color: Colors.orange[400],
                      child: ListTile(
                        title: Text(
                          snapshot.data.documents[i].data['carName'],
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                        ),
                        subtitle:
                            Text(snapshot.data.documents[i].data['color']),
                        // Put an icon on it
                        leading: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {},
                        ),
                        trailing: IconButton(
                          icon: (done)
                              ? Icon(Icons.thumb_up,
                                  color: Colors.green[600], size: 25.0)
                              : Icon(Icons.thumb_down,
                                  color: Colors.black38, size: 25.0),
                          onPressed: () {
                            /*
                              Code added by DVG, in order to make it a todo app
                              we should keep track of the status of a todo-item.
                            */
                            // Boolean trick, if user clicks on an open todo, the
                            // state true becomes false and vice versa
                            done = !done;

                            crudObj.updateStatus(
                                snapshot.data.documents[i].documentID,
                                {'status': done});
                            Scaffold.of(context).showSnackBar(new SnackBar(
                              content: Text("Task done is $done"),
                            ));
                          },
                        ),
                        onTap: () {
                          todoItem.docId =
                              snapshot.data.documents[i].documentID;
                          updateDialog(
                              context, snapshot.data.documents[i].documentID);
                        },
                        onLongPress: () {
                          // Add code to ask confirmation
                          _deleteRecordDialog(
                              context,
                              snapshot.data.documents[i].documentID,
                              snapshot.data.documents[i].data['carName']);
                        },
                      ),
                    ),
                  );
                },
              );
          }
          /* else {
              return 
                CircularProgressIndicator();
            }*/
        },
      ),
    );
  }

  /*
    Show the add record dialog
  */
  Future<bool> addDialog(BuildContext context) async {
    // Create a new todo item (without Id, we don't have it yet)
    todoItem = new TodoItem("", "", "", "", 0, 0, 0);
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Data', style: TextStyle(fontSize: 15.0)),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "Title",
                            hintText: 'Enter title',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0))),
                        validator: (val) =>
                            !val.contains('@') ? 'Invalid email' : null,
                        onSaved: (val) {
                          this.carModel = val;
                          todoItem.title = val;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "Task details",
                            hintText: 'enter details',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0))),
                        validator: (val) =>
                            val.length < 2 ? "Not a serious detail!" : null,
                        onSaved: (val) {
                          this.carModel = val;
                          todoItem.title = val;
                        },
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                              child: Text("Submit"), onPressed: _saveRecord),
                        ),
                        Expanded(
                            child: RaisedButton(
                          child: Text("Cancel"),
                          /* When cancel is clicked, yust navigate away */
                          onPressed: () => Navigator.of(context).pop(),
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  /* Validate todo form */
  void _saveRecord() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
    }
    /*
            actions: <Widget>[
              FlatButton(
                child: Text('Add'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                  // Prepare a new Todo Item
                  crudObj.addData({
                    'carName': this.carModel,
                    'color': this.carColor,
                    'status': false
                  }).then((result) {
                    dialogTrigger(context);
                  }).catchError((e) {
                    print(e);
                  });
                },
              )
            ],*/
  }

  /*
    Show an alert dialog asking if the selected record
    should be deleted.
  */
  Future<ConfirmAction> _deleteRecordDialog(
      BuildContext context, selectedDocID, selectedDocCarName) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove record?'),
          content: Container(
            height: 125.0,
            width: 150.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Selected car:'),
                Text(selectedDocCarName)
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
                child: const Text("DELETE"),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.DELETE);
                  crudObj.deleteData(selectedDocID);
                }),
          ],
        );
      },
    );
  }

  /*
    Show the update dialog, in fact there are twd possible updates in this
    app.  The todo, and the status of that todo (true, false)
  */
  Future<bool> updateDialog(BuildContext context, selectedDoc) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update Data', style: TextStyle(fontSize: 15.0)),
            content: Container(
              height: 125.0,
              width: 150.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(hintText: 'Enter ToDo Title'),
                    onChanged: (value) {
                      this.carModel = value;
                    },
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    decoration: InputDecoration(hintText: 'Enter car color'),
                    onChanged: (value) {
                      this.carColor = value;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Update'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                  todoItem
                    ..title = this.carModel
                    ..details = this.carColor
                    ..docId = selectedDoc;
                  crudObj
                      .updateData(
                          selectedDoc,
                          {'carName': this.carModel, 'color': this.carColor},
                          todoItem)
                      .then((result) {
                    // dialogTrigger(context);
                  }).catchError((e) {
                    print(e);
                  });
                },
              )
            ],
          );
        });
  }

  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Job Done', style: TextStyle(fontSize: 15.0)),
            content: Text('Added'),
            actions: <Widget>[
              FlatButton(
                child: Text('Alright'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
