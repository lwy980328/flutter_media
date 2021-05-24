
import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'package:flustars/flustars.dart';
import 'package:dio/dio.dart';
import 'package:sprintf/sprintf.dart';
import 'dio_utils.dart';
import 'error_handle.dart';
import 'package:flutter_media/util/utils.dart';
import 'package:flutter_media/util/common.dart';
import 'package:flutter_media/util/storage_manager.dart';
import 'package:flutter_media/util/log_utils.dart';


class AuthInterceptor extends Interceptor{
  @override
  onRequest(RequestOptions options,handler) async{
    String accessToken = await StorageManager.sharedPreferences.getString(Constant.access_Token);
    //  String accessToken = 'f5cf27d2-f9ec-450f-97a0-690882fc8863';

    if (accessToken!=null && accessToken!="") {
      options.headers["token"] = accessToken;
//        options.data
    }

    return super.onRequest(options,handler);
  }
}

class TokenInterceptor extends Interceptor{
  @override
  onError(DioError error,ErrorInterceptorHandler handler) async {
    //401代表token过期
    if (error.response != null && error.response.statusCode == ExceptionHandle.unauthorized) {
      Log.d("-----------自动刷新Token------------");
      Dio dio = DioUtils.instance.getDio();
      dio.lock();
      String accessToken = await getToken(); // 获取新的accessToken
      Log.e("-----------NewToken: $accessToken ------------");
      SpUtil.putString(Constant.access_Token, accessToken);
      dio.unlock();

      // 重新请求失败接口
      var request = error.requestOptions;
      try {
        var response = await dio.request(request.path,
            data: request.data,
            queryParameters: request.queryParameters,
            cancelToken: request.cancelToken,
            options: Options(method: request.method,
              sendTimeout:request.sendTimeout,
              receiveTimeout:request.receiveTimeout,
              extra:request.extra,
              headers:request.headers,
              responseType:request.responseType,
              contentType:request.contentType,
              validateStatus:request.validateStatus,
              receiveDataWhenStatusError: request.receiveDataWhenStatusError,
              followRedirects:request.followRedirects,
              maxRedirects: request.maxRedirects,
              requestEncoder: request.requestEncoder,
              responseDecoder: request.responseDecoder,
              listFormat: request.listFormat,
            ),
            onReceiveProgress: request.onReceiveProgress);
      } on DioError catch (e) {
        print(e);
      }
    }
    return super.onError(error,handler);
  }

  Future<String> getToken() async {

    Map<String, String> params = Map();
    params["refresh_token"] = SpUtil.getString(Constant.refresh_Token);
    try{
      var response = await DioUtils.instance.getDio().post("lgn/refreshToken", data: params);
      if (response.statusCode == ExceptionHandle.success){
        return json.decode(response.data.toString())["access_token"];
      }
    }catch(e){
      Log.e("刷新Token失败！");
    }
    return "";
  }
}

class LoggingInterceptor extends Interceptor{

  DateTime startTime;
  DateTime endTime;

  @override
  onRequest(RequestOptions options,handler) {
    startTime = DateTime.now();
    Log.d("----------Start----------");
    if (options.queryParameters.isEmpty){
      Log.i("RequestUrl: " + options.baseUrl + options.path);
    }else{
      Log.i("RequestUrl: " + options.baseUrl + options.path + "?" + Transformer.urlEncodeMap(options.queryParameters));
    }
    Log.d("RequestMethod: " + options.method);
    Log.d("RequestHeaders:" + options.headers.toString());
    Log.d("RequestContentType: ${options.contentType}");
    Log.d("RequestData: ${options.data.toString()}");
    return super.onRequest(options,handler);
  }

  @override
  onResponse(Response response,handler) {
    endTime = DateTime.now();
    int duration = endTime.difference(startTime).inMilliseconds;
    Log.d("----------End: $duration 毫秒----------");
    return super.onResponse(response,handler);
  }

  @override
  onError(DioError err,handler) {
    Log.d("----------Error-----------");
    return super.onError(err,handler);
  }
}

class AdapterInterceptor extends Interceptor{

  static const String MSG = "msg";
  static const String SLASH = "\"";
  static const String MESSAGE = "message";
  static const String ERROR = "validateErrors";

  static const String DEFAULT = "\"无返回信息\"";
  static const String NOT_FOUND = "未找到查询信息";

  static const String FAILURE_FORMAT = "{\"code\":%d,\"message\":\"%s\"}";
  static const String SUCCESS_FORMAT = "{\"code\":0,\"data\":%s,\"message\":\"\"}";

  @override
  onResponse(Response response,handler) {
    Response r = adapterData(response);
    return super.onResponse(r,handler);
  }

  @override
  onError(DioError err,handler) {
    if (err.response != null){
      adapterData(err.response);
    }
    return super.onError(err,handler);
  }

  Response adapterData(Response response){
    String result;
    String content = response.data.toString();
    /// 成功时，直接格式化返回
    if (response.statusCode == ExceptionHandle.success || response.statusCode == ExceptionHandle.success_not_content){
      if (content == null || content.isEmpty){
        content = DEFAULT;
      }
      result = sprintf(SUCCESS_FORMAT, [content]);
      response.statusCode = ExceptionHandle.success;
    }else{
      if (response.statusCode == ExceptionHandle.not_found){
        /// 错误数据格式化后，按照成功数据返回
        result = sprintf(FAILURE_FORMAT, [response.statusCode, NOT_FOUND]);
        response.statusCode = ExceptionHandle.success;
      }else {
        if (content == null || content.isEmpty){
          // 一般为网络断开等异常
          result = content;
        }else {
          String msg;
          try {
            content = content.replaceAll("\\", "");
            if (SLASH == content.substring(0, 1)){
              content = content.substring(1, content.length - 1);
            }
            Map<String, dynamic> map = json.decode(content);
            if (map.containsKey(ERROR) && map[ERROR].toString() != null && map[ERROR].toString() != "null" ){
              List errorJson = json.decode(map[ERROR].toString());
              if (errorJson.length == 1){
                msg = errorJson[0][MESSAGE];
              }else {
                if (map.containsKey(MESSAGE)){
                  msg = map[MESSAGE];
                }else if(map.containsKey(MSG)){
                  msg = map[MSG];
                }else {
                  msg = "";
                }
              }

            }else{
              if (map.containsKey(MESSAGE)){
                msg = map[MESSAGE];
              }else if(map.containsKey(MSG)){
                msg = map[MSG];
              }else {
                msg = "";
              }
            }
            result = sprintf(FAILURE_FORMAT, [response.statusCode, msg]);
            // 401 token失效时，单独处理，其他一律为成功
            if (response.statusCode == ExceptionHandle.unauthorized){
              response.statusCode = ExceptionHandle.unauthorized;
            }else {
              response.statusCode = ExceptionHandle.success;
            }
          } catch (e) {
            Log.d("异常信息：$e");
            // 解析异常直接按照返回原数据处理（一般为返回500,503 HTML页面代码）
            result = content;
          }
        }
      }
    }
    if (response.statusCode == ExceptionHandle.success){
      Log.d("ResponseCode: ${response.statusCode}");
    }else {
      Log.e("ResponseCode: ${response.statusCode}");
    }
    // 输入结果
    Log.json(result);
    response.data = result;
    return response;
  }
}

