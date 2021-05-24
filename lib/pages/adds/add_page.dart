

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media/pages/adds/start_product.dart';
import 'package:flutter_media/util/image_utils.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage>{


  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StartProductPage(),
    );
  }


}