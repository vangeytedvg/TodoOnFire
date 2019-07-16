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
    this.todoItem = new TodoItem.withId("", "", "", "", "", "", "", "");
    /*
     um = new UserProfile("Not set",
            "Not set",
            "Not set",
            "Not set",
            "Not set",
            "Not set",
            "Not set",
            "Not set",
            "Not set");*/
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
            "",
            "");
        print(docs.documents[0].data['email'] ?? "Not set");
      }
    });
    return new Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          //backgroundColor: Colors.orange[900],
          title: Text("Todo's On Fire!"),
          centerTitle: true,
        ),
        /*
           Define the drawer menu 
         */
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              // TODO: Make this show the data of the logged in user
              new UserAccountsDrawerHeader(
                // * Bugfix avoid null in db hence the ? ?? syntax
                accountEmail: Text(um?.email ?? "N/A"),
                accountName: Text(um?.nickName ?? "N/A"),
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
                    crudObj
                        .getData(Provider.of<UserTracker>(context).getUid())
                        .then((results) {
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
              new Divider(height: 12.0, indent: 12.0, color: Colors.grey),
              new ListTile(
                leading: Icon(EvaIcons.close, color: Colors.lime),
                title: Text("Close menu"),
                onTap: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
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
        body: _todoList());
  }

  // The actual todo-list is drawn here
  Widget _todoList() {
    print(">>>>---");
    print("User ID = ${Provider.of<UserTracker>(context).getUid()}");
    // The cars snapshot is reetrieved in the Widget Build method above
    return new Container(
        child: StreamBuilder(
            // This keeps track of changes in the DB itself.  Listeners....
            stream: Firestore.instance
                .collection('testscrud')
                .where('user_id',
                    isEqualTo: Provider.of<UserTracker>(context).getUid())
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              // Workaround for the builder null error
              if (snapshot.hasError) return new Text('${snapshot.error}');
              if (snapshot.data.documents.length == 0) {
                print("Ukkeldepukkel >>>>>>");
                return new Center(child: _showEmptyInHere());
              } else {
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
                                  icon: Icon(FeatherIcons.edit,
                                      color: Colors.blue),
                                  onPressed: () {
                                    setState(() {
                                      this.todoItem.docId =
                                          snapshot.data.documents[i].documentID;
                                      this.todoItem.title = snapshot
                                          .data.documents[i].data['todoTitle'];
                                      this.todoItem.details = snapshot
                                          .data.documents[i].data['todoDetail'];
                                    });
                                    _updateDialog(context);
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
                                String oldTodoTitle = snapshot
                                    .data.documents[i].data['todoTitle'];
                                String oldTodoDetail = snapshot
                                    .data.documents[i].data['todoDetail'];
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
                                      //crudObj.getData().then((results) {
                                      //  cars = results;
                                      //});
                                    },
                                  ),
                                ));
                              });
                            });
                      },
                    );
                }
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
    print('Undo activated');
    print(this.todoTitle);
    // Prepare a new Todo Item
    print(this.todoDetail);
    print("----------------------------------------");
    await crudObj.addData({
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
    print("User Identification..");
    print(Provider.of<UserTracker>(context).getUid());
    return await showDialog(
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
                            hintText: 'Enter details',
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
  void _saveRecord() {
    print('---->> _saveRecord called...');
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
        final snackbar = new SnackBar(
          content: new Text("Record added"),
        );
        scaffoldKey.currentState.showSnackBar(snackbar);
      }).catchError((e) {
        return (e);
      });
    }
  }

  /*
                    Update the information in the database
                  */
  void _updateRecord() {
    print('---->> _updateRecord called...');
    print(this.todoItem.title);
    print("${this.todoDetail}, ${this.todoTitle}");
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      Navigator.of(context).pop();
      // Prepare a new Todo Item
      crudObj.updateData(this.todoItem.docId, {
        'todoTitle': this.todoItem.title,
        'todoDetail': this.todoItem.details,
        'user_id': Provider.of<UserTracker>(context).getUid()
      }).then((result) {
        final snackbar = new SnackBar(
          content: new Text("Record updated"),
        );
        scaffoldKey.currentState.showSnackBar(snackbar);
      }).catchError((e) {
        return (e);
      });
    }
  }

  /*
                    Show the update dialog
                  */
  Future<bool> _updateDialog(BuildContext context) async {
    // Create a new todo item (without Id, we don't have it yet)
    print("User Identification is here:");
    print("Selected doc");
    print(this.todoItem.title);
    print(Provider.of<UserTracker>(context).getUid());
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update selected todo',
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
                        initialValue: this.todoItem.title,
                        decoration: InputDecoration(
                            labelText: "Title",
                            hintText: 'Enter title',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0))),
                        validator: (val) =>
                            val.length < 1 ? "Need a title!" : null,
                        onSaved: (val) {
                          setState(() {
                            this.todoItem.title = val;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextFormField(
                        initialValue: this.todoItem.details,
                        decoration: InputDecoration(
                            labelText: "Task details",
                            hintText: 'Enter details',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0))),
                        validator: (val) =>
                            val.length < 2 ? "Not a serious detail!" : null,
                        onSaved: (val) {
                          setState(() {
                            this.todoItem.details = val;
                          });
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
                                // TODO: Continue working on the update here
                                _updateRecord();
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
    await crudObj.deleteData(selectedDocID);
    return null;
  }

  _showEmptyInHere() {
    return new Center(
      child: Text("Hey, it's empty in here!!"),
    );
  }
}
