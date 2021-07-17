import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

// import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_socket_channel/io.dart';

/*
* @APPID:e2d143f9
* @APISecret:MzI4NTJmNzc3MGIwMDE0NDY5NmQzMGRi
* @APIKey:449844b95356cb6bb7f5db7742f105bc
* 接入讯飞语音转文字webAPI
* */
class ttsWebsocket {
  static final String APPID = "e2d143f9";
  static final String APISecret = "MzI4NTJmNzc3MGIwMDE0NDY5NmQzMGRi";
  static final String APIKey = "449844b95356cb6bb7f5db7742f105bc";
  static final String url = "wss://tts-api.xfyun.cn/v2/tts";
  String s = "";

  //私有构造方法
  ttsWebsocket._internal() {}

  static ttsWebsocket _manager;

  factory ttsWebsocket() {
    if (_manager == null) {
      _manager = new ttsWebsocket._internal();
    }
    return _manager;
  }

  IOWebSocketChannel channel;
  String tospeech ;

  void initWebSocket(String tospeech) async {
    String path = assembleAuthUrl();
    Directory directory = await getExternalStorageDirectory();
    String depath = directory.path;
    File f = File('$depath/test.mp3');
    if (f.existsSync()) {
      f.deleteSync();
    }
    channel = IOWebSocketChannel.connect(
      path,
    );
    this.tospeech = tospeech;
    channel.stream.listen(
        (message) {
          print(message);

          final Map<String, dynamic> mesData = json.decode(message);

          f.writeAsBytes(base64.decode(mesData["data"]["audio"]),
              mode: FileMode.append, flush: true);
          if (mesData["data"]["status"] == 2) {
            _onDone();
            playAudio(f.path);
          }
        },
        onDone: _onDone,
        onError: (e) {
          print(e);
        });

    sinkData(this.tospeech);



  }

  sinkData(String str){
    var text = base64Encode(utf8.encode(str??"没有传入字符串哦"));
    print(text);
    Map m = {
      "common": {"app_id": "$APPID"},
      "business": {
        "aue": "lame",
        "sfl": 1,
        "vcn": "xiaoyan",
        "pitch": 50,
        "speed": 60,
        "tte": "utf8"
      },
      "data": {"status": 2, "text": "$text"}
    };

    var j = json.encode(m);

    channel.sink.add(j);
  }

  void _onReceive(data) {
    print("收到服务器数据:" + data);
  }

  void _onDone() {
    print("链接关闭");
    print("数据写入完成");
    channel.sink.close();
  }

  void playAudio(String filepath) async{
    print(filepath);
    AudioPlayer audioPlayer = new AudioPlayer();
    await audioPlayer.play(filepath,isLocal: true);
    audioPlayer.onPlayerCompletion.listen((event) {
      audioPlayer.dispose();
      audioPlayer = null;
    });
  }

  String assembleAuthUrl() {

    print("------------------------------------------------------------------");
    String time = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", 'en')
        .format(DateTime.now())
        .toString();
    print(time);

    String sigenatur_origin =
        "host: tts-api.xfyun.cn\ndate: $time\nGET /v2/tts HTTP/1.1";
    print(sigenatur_origin);

    var signature_sha = Hmac(sha256, utf8.encode(APISecret));
    var digest = signature_sha.convert(utf8.encode(sigenatur_origin));

    var signature = base64.encode(digest.bytes);
    print("------signature is -----------" + signature);

    var authorization_origin =
        'api_key="$APIKey", algorithm="hmac-sha256", headers="host date request-line", signature="$signature"';
    print(authorization_origin);
    var authorization = base64.encode(utf8.encode(authorization_origin));
    print(authorization);

    var v = {
      "authorization": authorization,
      "date": time,
      "host": "tts-api.xfyun.cn"
    };
    var path = Uri(
        scheme: "wss",
        host: "tts-api.xfyun.cn",
        path: "/v2/tts",
        queryParameters: v);
    print(path);
    print("------------------------------------------------------------------");


    return path.toString();
  }
}
