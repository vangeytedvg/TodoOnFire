/*
  main.dart
  Application entrypoint for the Todo's on fire app.
  Author : Danny Van Geyte
  Github location : https://github.com/vangeytedvg/TodoOnFire
  Changelog : 
    - 17/07/2019 Finalizing stage 0.1.2.
                 Added drawer menu for about dialog
  
  TODO  * (Publish)
  TODO  * Add internationalisation (dutch, french in first instance)
  TODO  * Add possibility to add todo's for other users
  TODO  * Add a splash page?
  TODO  * Send email with todo's?
  TODO  * Make a real component of aniitem.dart (own) use achievement widget as example
*/

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'screens/dashboard.dart';
import 'screens/loginpage.dart';
import 'screens/signuppage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import './experimental/experiments.dart';
// State management
import 'services/track.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // We only have one for the moment, but prepare to have more
    // classes that will be needed for tracking purposes, so declare
    // a MultiProvider.
    return MultiProvider(
        providers: [
          // This makes this class a listener to the changes in UserTracker
          ChangeNotifierProvider(builder: (_) => UserTracker(false)),
        ],
        child: Consumer<UserTracker>(builder: (context, usertracker, _) {
          return new MaterialApp(
            title: "Todo''s On Fire!",
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Fira',
              brightness: Brightness.dark,
              primaryColor: Colors.lightGreen[600],
              primarySwatch: Colors.blue,
              accentColor: Colors.cyan[600],
              textTheme: TextTheme(
                headline:
                    TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
                title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
                body1: TextStyle(fontSize: 14.0, fontFamily: 'Arino'),
              ),
            ),
            home: MyHomePage(),
            routes: <String, WidgetBuilder>{
              '/landingpage': (BuildContext context) => new MyHomePage(),
              '/signup': (BuildContext context) => new SignupPage(),
              '/homepage': (BuildContext context) => new DashboardPage(),
              '/experiments': (BuildContext context) => new Experiments()
            },
          );
        }));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // Implementeren achteraf, voor de taal
    Locale loc = Localizations.localeOf(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Todo' 's on Fire!'),
        centerTitle: true,
      ),
      drawer: Drawer(
          elevation: 20.0,
          child: ListView(children: <Widget>[
            new UserAccountsDrawerHeader(
              // * Bugfix avoid null in db hence the ? ?? syntax
              accountEmail: Text("Todo's"),
              accountName: Text("On Fire!"),
              currentAccountPicture: CircleAvatar(
                child: Text("DVG"),
              ),
            ),
            ListTile(
              leading: Icon(FeatherIcons.camera, color: Colors.blue),
              title: Text("ML Vision Tests..."),
              onTap: () {
                Navigator.of(context).popAndPushNamed('/experiments');
              },
            ),
            ListTile(
              leading: Icon(
                FeatherIcons.info,
                color: Colors.amber,
              ),
              title: Text("Written and designed by Danny Van Geyte"),
              onTap: () {
              Navigator.of(context).pop();
              }),
          ])),
      body: new Center(
        child: LoginPage(),
        //child: Text("User state: $userTracker.isUserLoggedIn().toString()")),
        //child: LoginStateLabel(),
      ),
      //floatingActionButton: LoginUserButton(),
    );
  }
}

class LoginUserButton extends StatelessWidget {
  const LoginUserButton({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: (() {
        if (Provider.of<UserTracker>(context).isUserLoggedIn() == false) {
          Provider.of<UserTracker>(context).logInUser();
        } else {
          Provider.of<UserTracker>(context).logOffUser();
        }
      }),
      tooltip: 'Login',
      child: const Icon(Icons.add),
    );
  }
}

class LogOffUserButton extends StatelessWidget {
  const LogOffUserButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Provider.of<UserTracker>(context).logInUser(),
      tooltip: 'Logoff',
      child: const Icon(Icons.add),
    );
  }
}

class LoginStateLabel extends StatelessWidget {
  const LoginStateLabel({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final userLoginState = Provider.of<UserTracker>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text("Login state is"),
        Text("(${userLoginState.isUserLoggedIn()})"),
      ],
    );
  }
}
