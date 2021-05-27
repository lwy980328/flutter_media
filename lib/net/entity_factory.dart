import 'package:flutter_media/bean/content_bean.dart';
import 'package:flutter_media/bean/content_bean2.dart';
import 'package:flutter_media/bean/infoList_bean.dart';
import 'package:flutter_media/bean/overview_bean.dart';
import 'package:flutter_media/bean/user_bean.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    }else if(T.toString() == 'OverviewBean') {
      return OverviewBean.fromJson(json) as T;
    }else if(T.toString() == 'InfoListBean') {
      return InfoListBean.fromJson(json) as T;
    }else if(T.toString() == 'ContentBean') {
      return ContentBean.fromJson(json) as T;
    }else if(T.toString() == 'ContentBean2') {
      return ContentBean2.fromJson(json) as T;
    }else if(T.toString() == 'UserBean') {
      return UserBean.fromJson(json) as T;
    } else {
      return json as T;
    }
  }
}
