/*
  DVG Technical reminder for this code
  testscrud is like the name of the table
  FirebaseCRUD is the database
  DVG June 17, 2019
  Made a lot of modifications, so the app starts to look and behave like
  a todo list (but then one on steroids).
*/

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_onfire/models/user_profile.dart';
import 'package:todo_onfire/services/usermanagement.dart';
import '../services/crud.dart';
import '../models/todo.dart';
import '../services/track.dart';
import 'package:provider/provider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';

enum ConfirmAction { DELETE, CANCEL }
enum TodoState { DONE, NOTDONE }

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  String todoTitle;
  String todoDetail;
  TodoItem todoItem;
  bool done = false;
  UserProfile um;
  /* For firebase */
  QuerySnapshot cars;
  QuerySnapshot docs;
  CrudMethods crudObj = new CrudMethods();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(Provider.of<UserTracker>(context).getUid());
    crudObj
        .getProfileData(Provider.of<UserTracker>(context).getUid())
        .then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        um = new UserProfile(
            docs.documents[0].data['email'],
            docs.documents[0].data['password'],
            docs.documents[0].data['nickname'],
            docs.documents[0].data['gender'],
            docs.documents[0].data['birthdate'],
            docs.documents[0].data['name'],
            docs.documents[0].data['firstname'],
            "","");
        print(docs.documents[0].data['email']);
      }
    });
    return new Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          //backgroundColor: Colors.orange[900],
          title: Text("Todo's On Fire!"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                crudObj.getData().then((results) {
                  setState(() {
                    cars = results;
                  });
                });
              },
            ),
            IconButton(
              icon: Icon(FeatherIcons.logOut),
              tooltip: "Log off",
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('/landingpage');
              },
            )
          ],
        ),
        /*
           Define the drawer menu 
         */
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              // TODO: Make this show the data of the logged in user
              new UserAccountsDrawerHeader(
                accountEmail: Text(um.email),
                accountName: Text("${um.name} ${um.firstName} (${um.nickName})"),
                currentAccountPicture: CircleAvatar(
                  child: Text("DVG"),
                ),
              ),
              ListTile(
                  leading: Icon(
                    FeatherIcons.refreshCw,
                    color: Colors.amber,
                  ),
                  title: Text("Refresh list"),
                  onTap: () {
                    crudObj.getData().then((results) {
                      setState(() {
                        cars = results;
                      });
                    });
                    Navigator.of(context).pop();
                  }),
              new Divider(height: 12.0, indent: 12.0, color: Colors.white),
              new ListTile(
                leading: Icon(FeatherIcons.logOut, color: Colors.lime),
                title: Text("Logoff"),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed('/landingpage');
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.plus_one),
          onPressed: () {
            addDialog(context);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: _carList());
  }

  // The actual todo-list is drawn here
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
                    key: _key,
                    // Determines the number of tiles there need to be
                    // drawn in the listview.
                    itemCount: snapshot.data.documents.length,
                    padding: EdgeInsets.all(5.0),
                    // i is the varialble of the loop (uses itemCount in fact)
                    itemBuilder: (context, i) {
                      done = snapshot.data.documents[i].data['status'];
                      return Dismissible(
                          direction: DismissDirection.startToEnd,
                          // Build a key with the docid, this is needed to distinguish
                          // each item seperately
                          key: Key(snapshot.data.documents[i].documentID),
                          child: Card(
                            color: Color.fromRGBO(255, 255, 10, 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            elevation: 4.0,
                            child: ListTile(
                              title: Text(
                                snapshot.data.documents[i].data['todoTitle'],
                                style: TextStyle(
                                    color: Colors.green, fontSize: 18.0),
                              ),
                              subtitle: Text(
                                snapshot.data.documents[i].data['todoDetail'],
                                style: TextStyle(color: Colors.black87),
                              ),
                              // Put an icon on it
                              leading: IconButton(
                                icon:
                                    Icon(FeatherIcons.edit, color: Colors.blue),
                                onPressed: () {
                                  updateDialog(context,
                                      snapshot.data.documents[i].documentID);
                                },
                              ),
                              trailing: IconButton(
                                icon: (done)
                                    ? Icon(FeatherIcons.thumbsUp,
                                        color: Colors.green[600], size: 25.0)
                                    : Icon(FeatherIcons.thumbsDown,
                                        color: Colors.grey, size: 25.0),
                                onPressed: () {
                                  done = !done;
                                  crudObj.updateStatus(
                                      snapshot.data.documents[i].documentID,
                                      {'status': done});
                                  /*Scaffold.of(context)
                                      .showSnackBar(new SnackBar(
                                    content: Text("Task done is $done"),
                                  ));*/
                                },
                              ),
                            ),
                          ),
                          background: Container(
                            color: Colors.red,
                          ),
                          onDismissed: (direction) {
                            // Remember item that is about to be deleted
                            setState(() {
                              String oldTodoTitle =
                                  snapshot.data.documents[i].data['todoTitle'];
                              String oldTodoDetail =
                                  snapshot.data.documents[i].data['todoDetail'];
                              bool oldDone =
                                  snapshot.data.documents[i].data['status'];
                              /* Remove record from Firebase */
                              _deleteItemNow(context,
                                  snapshot.data.documents[i].documentID);
                              //* Give a chance to recover the item, this was a litte
                              //* hard to find out how it works, but it is ok now
                              scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text("Deleted $oldTodoTitle"),
                                action: SnackBarAction(
                                  label: "Ooops Don't delete!",
                                  onPressed: () {
                                    this.todoTitle = oldTodoTitle;
                                    this.todoDetail = oldTodoDetail;
                                    this.done = oldDone;
                                    _undoDeleteRecord(this.todoTitle,
                                        this.todoDetail, this.done);
                                    crudObj.getData().then((results) {
                                      cars = results;
                                    });
                                  },
                                ),
                              ));
                            });
                          });
                    },
                  );
              }
            }));
  }

  /*
    Undeletes a record.  In fact, it taks the data
    of the record that was swipped and reinserts that into 
    firebase. 
   */
  Future<void> _undoDeleteRecord(
      String oldTodoTitle, String oldTodoDetail, bool oldDone) async {
    print('----------------------------------------');
    print(this.todoTitle);
    // Prepare a new Todo Item
    print(this.todoDetail);
    print("----------------------------------------");
    crudObj.addData({
      'todoTitle': oldTodoTitle,
      'todoDetail': oldTodoDetail,
      'status': oldDone
    }).catchError((e) {
      print(e);
    });
  }

  /*
    Show the add record dialog
  */
  Future<bool> addDialog(BuildContext context) async {
    // Create a new todo item (without Id, we don't have it yet)
    todoItem = new TodoItem("", "", "", "", 0, 0, 0);
    print("User Identification..");
    print(Provider.of<UserTracker>(context).getUid());
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('New todo',
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold)),
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
                            val.length < 1 ? "Need a title!" : null,
                        onSaved: (val) {
                          this.todoTitle = val;
                          todoItem.title = val;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "Task details",
                            hintText: 'enter details',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0))),
                        validator: (val) =>
                            val.length < 2 ? "Not a serious detail!" : null,
                        onSaved: (val) {
                          this.todoDetail = val;
                          todoItem.details = val;
                        },
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                              child: Text(
                                "Submit",
                                style: TextStyle(color: Colors.green),
                              ),
                              onPressed: () {
                                _saveRecord();
                              }),
                        ),
                        Expanded(
                            child: FlatButton(
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
  String _saveRecord() {
    print('----------------------------------------');
    print(this.todoTitle);
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      Navigator.of(context).pop();
      // Prepare a new Todo Item
      crudObj.addData({
        'todoTitle': this.todoTitle,
        'todoDetail': this.todoDetail,
        'status': this.done,
        'user_id': Provider.of<UserTracker>(context).getUid()
      }).then((result) {
        //final snackbar = new SnackBar(
        //  content: new Text("Record added"),
        //);
        //scaffoldKey.currentState.showSnackBar(snackbar);
      }).catchError((e) {
        return (e);
      });
    }
    return "Ok";
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
                      this.todoTitle = value;
                    },
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    decoration: InputDecoration(hintText: 'Enter car color'),
                    onChanged: (value) {
                      this.todoDetail = value;
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
                    ..title = this.todoTitle
                    ..details = this.todoDetail
                    ..docId = selectedDoc;
                  crudObj
                      .updateData(
                          selectedDoc,
                          {'carName': this.todoTitle, 'color': this.todoDetail},
                          todoItem)
                      .then((result) {
                    // dialogTrigger(context);
                  }).catchError((e) {
                    print(e);
                  });
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
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

  Future<void> _deleteItemNow(
      BuildContext context, String selectedDocID) async {
    crudObj.deleteData(selectedDocID);
    return null;
  }
}
