
import 'package:shared_preferences/shared_preferences.dart';

import 'common.dart';


class Utils {

  static SharedPreferences sharedPreferences;


  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static exit() async {
    await sharedPreferences.setString(Constant.access_Token, '');
    // await myChannel.invokeMethod('logout');
    //Toast.show('退出登录成功');
    // eventBus.fire(new UserExit());
    print('退出登录');
  }
  static String getImgPath(String name) {
    return 'assets/images/$name';
  }

  static bool isLogin() {
    if(Utils.sharedPreferences != null){
      String token = Utils.sharedPreferences.getString(Constant.access_Token);
      return token!=null&&token!=''&&token.isNotEmpty;
    }
    return false;
  }


  static bool checkMobile(var sMobile){
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    bool matched = exp.hasMatch(sMobile);
    return matched;
  }

  static String dateAndTimeToString(var timestamp, {Map<String, String> formart}) {
    if (timestamp == null || timestamp == "") {
      return "";
    }
    String targetString = "";
    final date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    // final String tmp = date.toString();
    String year = date.year.toString();
    String month = date.month.toString();
    if(date.month<=9){
      month = "0" + month;
    }
    String day = date.day.toString();
    if(date.day<=9){
      day = "0" + day;
    }
    String hour = date.hour.toString();
    if(date.hour<=9){
      hour = "0" + hour;
    }
    String minute = date.minute.toString();
    if(date.minute<=9){
      minute = "0" + minute;
    }
    String second = date.second.toString();
    if(date.second<=9){
      second = "0" + second;
    }
    // String millisecond = date.millisecond.toString();
    String morningOrafternoon = "上午";
    if(date.hour >= 12){
      morningOrafternoon = "下午";
    }

    if(formart["y-m"] != null && formart["m-d"] != null){
      targetString = year + formart["y-m"] + month + formart["m-d"] + day;
    }else if(formart["y-m"] == null && formart["m-d"] != null){
      targetString = month + formart["m-d"] + day;
    }else if(formart["y-m"] != null && formart["m-d"] == null){
      targetString = year + formart["y-m"] + month;
    }

    targetString += " ";

    if(formart["m-a"] != null){
      targetString += morningOrafternoon + " ";
    }

    if(formart["h-m"] != null && formart["m-s"] != null){
      targetString +=  hour + formart["h-m"] + minute + formart["m-s"] + second;
    }else if(formart["h-m"] == null && formart["m-s"] != null){
      targetString +=  minute + formart["m-s"] + second;
    }else if(formart["h-m"] != null && formart["m-s"] == null){
      targetString += hour + formart["h-m"] + minute;
    }

    return targetString;

  }
}
