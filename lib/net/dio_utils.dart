import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_media/util/utils.dart';
import 'package:flutter_media/util/toast.dart';
import 'package:flutter_media/util/log_utils.dart';
import 'base_entity.dart';
import 'config.dart';
import 'entity_factory.dart';
import 'error_handle.dart';
import 'intercept.dart';

class DioUtils {

  static final DioUtils _singleton = DioUtils._internal();

  static DioUtils get instance => DioUtils();

  factory DioUtils() {
    return _singleton;
  }

  static Dio _dio;

  Dio getDio(){
    return _dio;
  }

  DioUtils._internal(){
    var options = BaseOptions(
      connectTimeout: 60000,
      receiveTimeout: 60000,
      responseType: ResponseType.plain,
      validateStatus: (status){
        // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
        return true;
      },
//      baseUrl: "http://10.128.246.120:8080/jeecg",
      //    baseUrl: 'https://www.aireading.club/jeecg',
      baseUrl: Config.apiHost,
//      baseUrl: 'http://ygyd.aireading.top/jeecg',
//    baseUrl: "http://10.128.252.164:8080/jeecg",
//      contentType: ContentType('application', 'x-www-form-urlencoded', charset: 'utf-8'),
    );
    _dio = Dio(options);
    /// 统一添加身份验证请求头
    _dio.interceptors.add(AuthInterceptor());
    /// 刷新Token
    _dio.interceptors.add(TokenInterceptor());
    /// 打印Log
    _dio.interceptors.add(LoggingInterceptor());
    /// 适配数据
    _dio.interceptors.add(AdapterInterceptor());
  }

  // 数据返回格式统一，统一处理异常
  Future<BaseEntity<T>> _request<T>(String method, String url, {dynamic data, Map<String, dynamic> queryParameters, CancelToken cancelToken, Options options}) async {
    var response = await _dio.request(url, data: data, queryParameters: queryParameters, options: _checkOptions(method, options), cancelToken: cancelToken);
    int _customCode;
    int _statusCode;
    String _msg;
    T _obj;

    try {
      Map<String, dynamic> _map = json.decode(response.data.toString());
      Map<String,dynamic> dataMap = _map["data"];
      _customCode = dataMap['customCode'];
      _statusCode = dataMap["statusCode"];
      _msg = dataMap["msg"];
      if(dataMap['obj'] == null){

      }
      if (dataMap.containsKey("obj")){
        if(dataMap['obj'] == null){
          _obj = null;
        }else{
          _obj = EntityFactory.generateOBJ(dataMap["obj"]);
        }

      }
    }catch(e){
      print(e);
      return parseError();
    }
    return BaseEntity(_customCode,_statusCode, _msg, _obj);
  }

  Future<BaseEntity<List<T>>> _requestList<T>(String method, String url, {dynamic data, Map<String, dynamic> queryParameters, CancelToken cancelToken, Options options}) async {
    var response = await _dio.request(url, data: data, queryParameters: queryParameters, options: _checkOptions(method, options), cancelToken: cancelToken);
    int _customCode;
    int _statusCode;
    String _msg;
    List<T> _obj = [];

    try {
      Map<String, dynamic> _map = json.decode(response.data.toString());
      Map<String,dynamic> dataMap = _map["data"];
      _customCode = dataMap['customCode'];
      _statusCode = dataMap["statusCode"];
      _msg = dataMap["msg"];
      if (dataMap.containsKey("obj")){
        ///  List类型处理，暂不考虑Map
        if(dataMap["obj"]==null){
          _obj=[];
        }
        else{
          (dataMap["obj"] as List).forEach((item){

            _obj.add(EntityFactory.generateOBJ<T>(item));
          });
        }
        BaseEntity(_customCode,_statusCode, _msg, _obj);
      }
    }catch(e){
      print(e);
      return parseError();
    }
    return BaseEntity(_customCode,_statusCode, _msg, _obj);
  }

  BaseEntity parseError(){
    return BaseEntity(ExceptionHandle.parse_error,ExceptionHandle.parse_error, "数据解析错误", null);
  }

  Options _checkOptions(method, options) {
    if (options == null) {
      options = new Options();
    }
    options.method = method;
    return options;
  }

  Future<BaseEntity<T>> request<T>(String method, String url, {dynamic params, Map<String, dynamic> queryParameters, CancelToken cancelToken, Options options}) async {
    var response = await _request<T>(method, url, data: params, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
    return response;
  }

  Future<BaseEntity<List<T>>> requestList<T>(String method, String url, {dynamic params, Map<String, dynamic> queryParameters, CancelToken cancelToken, Options options}) async {
    var response = await _requestList<T>(method, url, data: params, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
    return response;
  }

  /// 统一处理(onSuccess返回T对象，onSuccessList返回List<T>)
  requestNetwork<T>(Method method, String url, {Function(T t) onSuccess,Function() onParseError,Function() noExistError,Function() alreadyExistError,
    Function() mismatchingError,Function() expiredError,Function(List<T> list) onSuccessList, Function(int code, String mag) onError,
    dynamic params, Map<String, dynamic> queryParameters, CancelToken cancelToken, Options options, bool isList : false}){
    String m;
    switch(method){
      case Method.get:
        m = "GET";
        break;
      case Method.post:
        m = "POST";
        break;
      case Method.put:
        m = "PUT";
        break;
      case Method.patch:
        m = "PATCH";
        break;
      case Method.delete:
        m = "DELETE";
        break;
    }
    if(params is Map) {
      params = FormData.fromMap(params);
    }

    Stream.fromFuture(isList ? requestList<T>(m, url, params: params, queryParameters: queryParameters, options: options, cancelToken: cancelToken) :
    request<T>(m, url, params: params, queryParameters: queryParameters, options: options, cancelToken: cancelToken))
        .asBroadcastStream()
        .listen((result){
      if (result.statusCode == 1){
        if(result.customCode == 0){
          onParseError();
        }else if(result.customCode == -1){
          noExistError();
        }else if(result.customCode == -2){
          mismatchingError();
        }else if(result.customCode == -3){
          expiredError();
        }else{
          isList ?onSuccessList(result.obj) : onSuccess(result.obj);
        }

      }else if(result.statusCode == -2){
        alreadyExistError();
      }else if(result.statusCode == -3){
        noExistError();
      }else if(result.statusCode == 104){
//        eventBus.fire(LoginEvent());
        Toast.show("用户授权信息无效");
      }else if(result.statusCode == 105){
        Toast.show("用户收取信息已过期");
      }else if(result.statusCode == 106){
        Toast.show("用户账户被禁用");
      }else if(result.statusCode == 120 || result.statusCode == 121){
        print("app需要升级");
        // eventBus.fire(LoginEvent(AppUpgradeInfo.fromMap(result.obj),result.statusCode));
      }else if(result.statusCode == -11){
        // eventBus.fire(LoginEvent('账户登录信息已过期，请重新登录',2));
      }else{
        onError == null ? _onError(result.statusCode, result.msg) : onError(result.statusCode, result.msg);
//        eventBus.fire(LoginEvent());
      }
    }, onError: (e){
      if (e is DioError && CancelToken.isCancel(e)){
        print("取消请求接口： $url");
      }
      Error error = ExceptionHandle.handleException(e);
      onError == null ? _onError(error.code, error.msg) : onError(error.code, error.msg);
    });
  }

  _onError(int code, String mag){
    Log.e("接口请求异常： code: $code, mag: $mag");
    Toast.show(mag);
  }
}

enum Method {
  get,
  post,
  put,
  patch,
  delete,
}
