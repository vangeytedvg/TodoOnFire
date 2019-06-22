/*
  buttons.dart
  Several shapes adaptions on buttons
  Author : DVG
  Created June 22, 2019
*/
import 'package:flutter/material.dart';

class RoundedRaisedButton extends StatelessWidget {
  // The VoidCallback statement allows the creation of a widget with
  // an event handler.  In this case I create the onPushButton event.
  // See loginpage.dart of a usage example.
  final VoidCallback onPushButton;
  const RoundedRaisedButton({Key key, this.onPushButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      textColor: Colors.white,
      child: Text('Login'),
      color: Colors.blue,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      onPressed: () {
        // Invoke the VoidCallBack
        onPushButton();
      },
    );
  }
}
