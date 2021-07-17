import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media/pages/adds/CameraPage.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {

  bool offstage = false;
  @override
  Widget build(BuildContext context) {
    final double rpx = MediaQuery.of(context).size.width / 750;

    return Stack(
      children: [
        CameraPage(),

      ],
    );
  }
}
