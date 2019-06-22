import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/dashboard.dart';
import 'screens/loginpage.dart';
import 'screens/signuppage.dart';
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
            title: "Todo On Fire!",
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
              '/homepage': (BuildContext context) => DashboardPage(),
              '/landingpage': (BuildContext context) => new MyApp(),
              '/signup': (BuildContext context) => new SignupPage(),
              '/homepage': (BuildContext context) => new DashboardPage()
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Todo' 's on Fire!'),
        centerTitle: true,
      ),
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
        };
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
