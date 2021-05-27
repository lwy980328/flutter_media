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

  Dio getDio() {
    return _dio;
  }

  DioUtils._internal() {
    var options = BaseOptions(
      connectTimeout: 15000,
      receiveTimeout: 15000,
      responseType: ResponseType.plain,
      validateStatus: (status) {
        // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
        return true;
      },
      baseUrl: Config.apiHost,
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
  Future<BaseEntity<T>> _request<T>(String method, String url,
      {FormData data,
        Map<String, dynamic> queryParameters,
        CancelToken cancelToken,
        Options options}) async {
    var response = await _dio.request(url,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions(method, options),
        cancelToken: cancelToken);
//    int _customCode;
    int _code;
    String _msg;
    T _obj;

    try {
      Map<String, dynamic> _map = json.decode(response.data.toString());
      Map<String, dynamic> dataMap = _map["data"];
//      _customCode = dataMap['customCode'];
      _code = dataMap["statusCode"];
      _msg = dataMap["msg"];
      if (dataMap.containsKey("data")) {
        if (dataMap['data'] == null) {
          _obj = null;
        } else {
          _obj = EntityFactory.generateOBJ(dataMap["data"]);
        }
      }
    } catch (e) {
      print(e);
      return parseError();
    }
    return BaseEntity(_code, _msg, _obj);
  }

  Future<BaseEntity<List<T>>> _requestList<T>(String method, String url,
      {FormData data,
        Map<String, dynamic> queryParameters,
        CancelToken cancelToken,
        Options options}) async {
    var response = await _dio.request(url,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions(method, options),
        cancelToken: cancelToken);
    int _customCode;
    int _code;
    String _msg;
    List<T> _obj = [];

    try {
      Map<String, dynamic> _map = json.decode(response.data.toString());
      Map<String, dynamic> dataMap = _map["data"];
//      _customCode = dataMap['customCode'];
      _code = dataMap["statusCode"];
      _msg = dataMap["msg"];
      if (dataMap.containsKey("data")) {
        ///  List类型处理，暂不考虑Map
        (dataMap["data"] as List).forEach((item) {
          _obj.add(EntityFactory.generateOBJ<T>(item));
        });
        BaseEntity(_code, _msg, _obj);
      }
    } catch (e) {
      print(e);
      return parseError();
    }
    return BaseEntity(_code, _msg, _obj);
  }

  BaseEntity parseError() {
    return BaseEntity(ExceptionHandle.parse_error, "数据解析错误", null);
  }

  Options _checkOptions(method, options) {
    if (options == null) {
      options = new Options();
    }
    options.method = method;
    return options;
  }

  Future<BaseEntity<T>> request<T>(String method, String url,
      {FormData params,
        Map<String, dynamic> queryParameters,
        CancelToken cancelToken,
        Options options}) async {
    var response = await _request<T>(method, url,
        data: params,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken);
    return response;
  }

  Future<BaseEntity<List<T>>> requestList<T>(String method, String url,
      {FormData params,
        Map<String, dynamic> queryParameters,
        CancelToken cancelToken,
        Options options}) async {
    var response = await _requestList<T>(method, url,
        data: params,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken);
    return response;
  }

  /// 统一处理(onSuccess返回T对象，onSuccessList返回List<T>)
  requestNetwork<T>(Method method, String url,
      {Function(T t) onSuccess,
        Function() onParseError,
        Function(int code, String mag) noExistError,
        Function() mismatchingError,
        Function() expiredError,
        Function(List<T> list) onSuccessList,
        Function(int code, String mag) onError,
        FormData params,
        Map<String, dynamic> queryParameters,
        CancelToken cancelToken,
        Options options,
        bool isList: false}) {
    String m;
    switch (method) {
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
    Stream.fromFuture(isList
        ? requestList<T>(m, url,
        params: params,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken)
        : request<T>(m, url,
        params: params,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken))
        .asBroadcastStream()
        .listen((result) {
      if (result.statusCode == 0) {
        isList ? onSuccessList(result.data) : onSuccess(result.data);
      } else if (result.statusCode == 102) {
        noExistError(result.statusCode, result.msg);
      } else if (result.statusCode == 104) {
//        eventBus.fire(LoginEvent());
        Toast.show("用户授权信息无效");
      } else if (result.statusCode == 105) {
        Toast.show("用户收取信息已过期");
      } else if (result.statusCode == 106) {
        Toast.show("用户账户被禁用");
      } else if (result.statusCode == -2) {
        Toast.show("账户登录信息已过期，请重新登录");
        Utils.exit();
//        eventBus.fire(LoginEvent('账户登录信息已过期，请重新登录'));
      } else {
        onError == null
            ? _onError(result.statusCode, result.msg)
            : onError(result.statusCode, result.msg);
//        eventBus.fire(LoginEvent());
      }
    }, onError: (e) {
      if (CancelToken.isCancel(e)) {
        print("取消请求接口： $url");
      }
      Error error = ExceptionHandle.handleException(e);
      onError == null
          ? _onError(error.code, error.msg)
          : onError(error.code, error.msg);
    });
  }

  _onError(int code, String mag) {
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