
import 'dart:io';

import 'package:flutter/services.dart';

class Log{
  
  static const perform = const MethodChannel("x_log");
  
  static d(String msg, {tag: 'X-LOG'}) {
//    if(Platform.isAndroid) {
////      perform.invokeMethod('logD', {'tag': tag, 'msg': msg});
////    } else {
      print(DateTime.now().toString()+" [$tag] [debug] $msg");
//    }
  }
  
  static w(String msg, {tag: 'X-LOG'}) {
//    if(Platform.isAndroid) {
//      perform.invokeMethod('logW', {'tag': tag, 'msg': msg});
//    } else {
      print(DateTime.now().toString()+" [$tag] [warn]  $msg");
//    }
  }

  static i(String msg, {tag: 'X-LOG'}) {
//    if(Platform.isAndroid) {
//      perform.invokeMethod('logI', {'tag': tag, 'msg': msg});
//    } else {
      print(DateTime.now().toString()+" [$tag] [info]  $msg");
//    }
  }
  
  static e(String msg, {tag: 'X-LOG'}) {
//    if(Platform.isAndroid) {
//      perform.invokeMethod('logE', {'tag': tag, 'msg': msg});
//    } else {
      print(DateTime.now().toString()+" [$tag] [error] $msg");
//    }

  }
  
  static json(String msg, {tag: 'X-LOG'}) {
    print(DateTime.now().toString()+" [$tag] [json]  $msg");
    /*try {
      perform.invokeMethod('logJson', {'tag': tag, 'msg': msg});
    } catch (e) {
      d(msg);
    }*/
  }
}