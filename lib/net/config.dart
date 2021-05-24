enum Env {
  LOCAL, TEST, PRODUCT, IOS_AUDIT
}

class Config {
  static Env env;

  static String get apiHost {
    switch (env) {
      case Env.LOCAL:
        return "http://49.232.168.124/jeecg";
      case Env.TEST:
        return "http://10.28.233.75:8080/jeecg";
      default:
//        return "http://47.103.3.88:8099/api";
//       return "http://testedu.happykit.cn:8098/api";//中小学测试机地址
//         return "https://school.unistudy.top/api";
        return "https://me.unistudy.top/api";//中小学正式机地址
//          return "http://10.28.165.87:8089";

//     return "http://10.28.250.180:8089";
    }
  }


}