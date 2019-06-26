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
  // See loginpage.dart of a usage example.  The example also
  // shows how to use named parameters (label, color)
  final VoidCallback onPushButton;
  final Text label;
  final Color buttonColor;
  final Color fontColor;
  const RoundedRaisedButton(
      {Key key,
      this.onPushButton,
      this.label,
      this.buttonColor,
      this.fontColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        textColor: fontColor,
        child: label,
        color: buttonColor,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () {
          // Invoke the VoidCallBack
          onPushButton();
        },
      ),
    );
  }
}
