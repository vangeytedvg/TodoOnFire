/*
  This widget shows an animated text used in the
  dashboard. 
  Author : DVG
  It is my first attempt on making a real reusable widget in flutter.
  Change log
    - 16/07/2019 Created
    - 18/07/2019 First attempt to create a reusable widget
*/
import 'package:flutter/material.dart';

class AnimEmptyBox extends StatefulWidget {
  final Duration duration;
  final String label;
  final Color color;
  final double fontSize;

  // By adding these fields to the constructor, the names of the fields
  // is shown in the intellisense.  Just like a regular widget.
  AnimEmptyBox({
    this.color: Colors.blue,
    this.label: "",
    this.duration: const Duration(seconds: 2),
    this.fontSize: 15.0
  });

  @override
  _AnimEmptyBoxState createState() => _AnimEmptyBoxState();
}

class _AnimEmptyBoxState extends State<AnimEmptyBox>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController)
      ..addListener(() {
        setState(() {
          // Nothing in here, but the setstate call tells the widget that a frame has passed
          // so it should redraw itself.
        });
      });
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: Center(
          child: FadeTransition(
        opacity: _animation,
        //child: Transform.rotate(child: Text("It's empty in Here!!"), angle: _animation.value,)),
        child: Text(widget.label,
          style: TextStyle(fontSize: widget.fontSize),
        ),
      )),
    ));
  }
}
