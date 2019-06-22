/*
  imagewidgets.dart
  Contains specialised widgets derived from the image class.
  Author : DVG
  Created June 22, 2019
*/

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

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
          Center(
            child: Text(
              "Please provide your credentials or signup...",
              style: TextStyle(color: Colors.white30),
            ),
          ),
          Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.005)
              ..rotateX(0.5),
            alignment: FractionalOffset.center,
            child: image,
          ),
        ]);
  }
}

/*
  Same as LoginImage, but this one has an animation added to the 
  icon.
  Found inspiration on this page: https://github.com/tensor-programming/Flutter_Animation/blob/master/lib/main.dart
*/
class AnimatedLoginImage extends StatefulWidget {
  @override
  _AnimatedLoginImageState createState() => _AnimatedLoginImageState();
}

class _AnimatedLoginImageState extends State<AnimatedLoginImage>
    with SingleTickerProviderStateMixin {
  Animation animation;
  int times = 0;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    animation = Tween(begin: 100.0, end: 170.0).animate(animationController);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        times += 1;
        if (times>2) {
          animationController.reverse();
          animationController.stop();
        } else { 
          animationController.reverse();
        }
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

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
          Center(
            child: Text(
              "Please provide your credentials or signup...",
              style: TextStyle(color: Colors.white30),
            ),
          ), LoginLogoAnimation(animation: this.animation,),

          /*Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.006)
              ..rotateX(0.5),
            alignment: FractionalOffset.center,
            child: image,*/
        
        ]);
  }
}

class LoginLogoAnimation extends AnimatedWidget {
  LoginLogoAnimation({Key key, Animation animation}) : super(key:key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('images/logintoweb.png');
    Animation animation = listenable;
    Image image = Image(
      image: assetImage,
      height: animation.value,
      width: animation.value
    );
    
    return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, animation.value / 10000.0)
              ..rotateX(animation.value/1000.0),
            alignment: FractionalOffset.center,
            child:image);
  }
}