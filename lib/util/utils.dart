
import 'package:shared_preferences/shared_preferences.dart';

import 'common.dart';


class Utils {

  static SharedPreferences sharedPreferences;


  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static exit() async {
    await sharedPreferences.setString(Constant.access_Token, '');
    await sharedPreferences.setString(Constant.school_Id, '0');
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

  static Future<String> getSchoolId() async{
    //注意schoolid = 'null'
    String schoolid =  Utils.sharedPreferences.getString(Constant.school_Id);
    if(schoolid!= null){
      return schoolid;
    }else{
      return '0';
    }
  }

}
