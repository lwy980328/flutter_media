import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common.dart';

class StorageManager {

  static SharedPreferences sharedPreferences;
  // static JPush jpush;
  static dynamic ctx;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    // jpush = new JPush();
  }

  static exite() async {
    await StorageManager.sharedPreferences.setString(Constant.access_Token, '');
  }

}
