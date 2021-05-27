import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_media/widget/fading_circle.dart';

class LoadingWidget {
  static Widget childWidget() {
    Widget childWidget = new Stack(
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 35.0),
          child: new Center(
            child: SpinKitFadingCircle(
              color: Colors.blueAccent,
              size: 30.0,
            ),
          ),
        ),
        new Padding(
          padding: new EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
          child: new Center(
            child: new Text("加载中，请稍后~~"),
          ),
        ),
      ],
    );
    return childWidget;
  }
}
