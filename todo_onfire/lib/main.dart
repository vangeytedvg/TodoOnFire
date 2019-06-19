import 'package:flutter/material.dart';
import 'screens/dashboard.dart';
import 'screens/loginpage.dart';
import 'screens/signuppage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
      routes:<String, WidgetBuilder> {
        '/homepage' : (BuildContext context) => DashboardPage(),
         '/landingpage': (BuildContext context)=> new MyApp(),
        '/signup': (BuildContext context) => new SignupPage(),
        '/homepage': (BuildContext context) => new DashboardPage()
      },
    );
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
        title: new Text('Crud sample'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: new Center(
        child: LoginPage(),
      ),
    );
  }
}