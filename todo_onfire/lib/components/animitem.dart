import 'package:flutter/material.dart';

class AnimEmptyBox extends StatefulWidget {
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
        AnimationController(duration: Duration(seconds: 2), vsync: this);
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
        child: Text("It's empty in here!", style: TextStyle(fontSize: 25.0),),
      )),
    ));
  }
}
