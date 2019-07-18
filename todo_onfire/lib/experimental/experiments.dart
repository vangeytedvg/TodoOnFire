import 'dart:io';

//import 'package:firebase_ml_vision/firebase_ml_vision.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class Experiments extends StatefulWidget {
  @override
  _ExperimentsState createState() => _ExperimentsState();
}

class _ExperimentsState extends State<Experiments> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  File pickedImage;
  bool isImageLoaded = false;

  Future pickImage() async {
  /*  print("Wazaaaa");
    File tempStore = await ImagePicker.pickImage(source: ImageSource.camera);
    print("Kwakkedikwak");
    if (tempStore != null) {
      setState(() {
        pickedImage = tempStore;
        isImageLoaded = true;
      });
    } else {
      print("Zoembawamba");
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Experimental Zone"),
          centerTitle: false,
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 100.0,
            ),
            isImageLoaded
                ? Center(
                    child: Container(
                    height: 200.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(pickedImage), fit: BoxFit.cover)),
                  ))
                // This is the 'else' part
                : Container(),
            SizedBox(height: 10.0),
            RaisedButton(
              child: Text("Pick an image"),
              onPressed: pickImage,
            ),
            SizedBox(height: 10.0),
            RaisedButton(
              child: Text("Read Text"),
              onPressed: () {},
            ),
          ],
        ));
  }
}
