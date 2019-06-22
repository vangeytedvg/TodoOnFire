/*
  imagewidgets.dart
  Contains specialised widgets derived from the image class.
  Author : DVG
  Created June 22, 2019
*/

import 'package:flutter/material.dart';

/*
  Simple static login image and text
*/
class LoginImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('images/logintoweb.png');
    Image image = Image(
      image: assetImage,
      height: 150.0,
      width: 150.0,
    );
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Text(
            "Welcome to the Todo's on fire app",
            style: TextStyle(
                fontFamily: 'Arino',
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          )),
          Center(child: Text(
            "Please provide your credentials or signup...", style:
            TextStyle(color: Colors.white30),),),

            Transform(transform: Matrix4.identity()
              ..setEntry(3, 2, 0.005)
              ..rotateX(0.5),
              alignment: FractionalOffset.center,
              child: image,),

        ]);
  }
}

/*
  Same as LoginImage, but this one has an animation added to the 
  icon.
*/
class AnimatedLoginImage extends StatefulWidget {
  @override
  _AnimatedLoginImageState createState() => _AnimatedLoginImageState();
}

class _AnimatedLoginImageState extends State<AnimatedLoginImage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('images/logintoweb.png');
    Image image = Image(
      image: assetImage,
      height: 150.0,
      width: 150.0,
    );
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Text(
            "Welcome to the Todo's on fire app",
            style: TextStyle(
                fontFamily: 'Arino',
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          )),
          Center(child: Text(
            "Please provide your credentials or signup...", style:
            TextStyle(color: Colors.white30),),),

            Transform(transform: Matrix4.identity()
              ..setEntry(3, 2, 0.005)
              ..rotateX(0.5),
              alignment: FractionalOffset.center,
              child: image,),

        ]);
  }
}