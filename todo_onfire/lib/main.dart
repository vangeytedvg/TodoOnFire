import 'package:flutter/material.dart';
 
//pages
import 'screens/dashboard.dart';
import 'screens/loginpage.dart';
import 'screens/signuppage.dart';
 
void main() => runApp(new MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: LoginPage(),
      routes: <String, WidgetBuilder> {
        '/landingpage': (BuildContext context)=> new MyApp(),
        '/signup': (BuildContext context) => new SignupPage(),
        '/homepage': (BuildContext context) => new DashboardPage()
      },
    );
  }
}