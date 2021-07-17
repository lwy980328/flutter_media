import 'dart:async';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_html/shims/dart_ui.dart';
import 'package:flutter_media/pages/adds/videoFileList.dart';
import 'package:flutter_media/pages/adds/video_0_bean.dart';
import 'package:flutter_media/pages/tts/ttswebsocket.dart';
import 'package:flutter_media/util/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'VideoPage.dart';
import '../../main.dart';
import 'content_info.dart';
import 'video_bean.dart';
// import 'package:flutter_tts/flutter_tts.dart';

class CameraPage extends StatelessWidget {
  final video0bean video0;
  const CameraPage({Key key,@required this.video0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CameraMain(
        rpx: MediaQuery.of(context).size.width / 750,
        video0: video0,
      ),
      bottomNavigationBar: BottomAppBar(),
    );
  }
}

typedef _CallBack = void Function(
    XFile file, CameraController cameraController);

class CameraMain extends StatefulWidget {
  final double rpx;
  final video0bean video0;
  CameraMain({Key key, @required this.rpx,this.video0}) : super(key: key);

  @override
  _CameraMainState createState() => _CameraMainState();
}

class _CameraMainState extends State<CameraMain> {
  // CameraProvider provider;
  double rpx;
  double toTop;
  double outBox;
  double innerBox;
  CameraController _cameracontroller;
  XFile videoFile;
  File uploadFile;
  Future _initializeControllerFuture;
  XFile imageFile;
  VideoPlayerController videoController;
  List<String> uriList = List();
  videoFileList videoList;
  // List<videoBean> videoBeanList;

  // FlutterTts flutterTts = FlutterTts();

  // List<CameraDescription> i ;
  bool offstage = true;
  int position = 1;
  videoBean cur;
  bool makesured = true;



  int curCamera = 0;

  getData() async {
    print('------------------------------');
    var options = BaseOptions(
      // responseType: ResponseType.plain,
        baseUrl: 'http://39.105.219.200:8089',
        method: 'GET',
        queryParameters: {'templateVideoId':widget.video0.id,'position':position}
      // contentType: 'multipart/form-data;boundary=<calculated when request is sent>',
    );

    var response = await Dio(options).request('/template/video/detail/getByTemplateIdAndPos');
    print(response.realUri);


    print('Response status: ${response.statusCode}');
    print('Response body: ${response.data}');
    if (response.statusCode == 200) {
      setState(() {
        print(response.data['data']['id']);
        cur = new videoBean(response.data['data']['id'], response.data['data']['position'], response.data['data']['templateVideoId'], response.data['data']['boardUrl'],response.data['data']['tips'],response.data['data']['words']);
        ttsWebsocket().initWebSocket(response.data['data']['tips']);
        // video0 = new video0bean(id??0, videoUrl??'', keywords??'', filter??0);
        print('------------------------------');


      });
    }
  }

  getCameras() async {
    // CameraDescription i1 = CameraDescription(name: '1',lensDirection:CameraLensDirection.front,sensorOrientation: 180);
    // CameraDescription i0 = CameraDescription(name: '0',lensDirection:CameraLensDirection.back,sensorOrientation: 90);
    // i = [i0,i1];
    _cameracontroller = CameraController(
        cameras[curCamera], ResolutionPreset.high,
        enableAudio: true);
    _initializeControllerFuture = _cameracontroller.initialize();

    // _controller.initialize().then((_) {
    //   if (!mounted) {
    //     return;
    //   }
    //   // _controller.startImageStream((CameraImage availableImage) {
    //   //   _controller.stopImageStream();
    //   //   // _scanFrame(availableImage);
    //   // });
    //
    //   setState(() {});
    // });
  }

  vflip() async {
    if (videoList.lengthIs() == 2) {
      Directory directory = await getExternalStorageDirectory();
      String path = directory.path;
      String command = " -i $path/2.mp4 -vf vflip -y $path/2l.mp4";
      final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
      _flutterFFmpeg.execute(command).then((rc) {
        print("------------视频已翻转--------------");
        Toast.show("第${videoList.lengthIs()}幕已翻转");
      });
    }
  }

  mixMusic(String audiopath, String videopath, String videoname,
      String silence) async {
    // File f = File('$videoname');
    // if(f.existsSync()){
    //   f.deleteSync();
    // }
    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    String command0 = ' -y -i $videopath -vcodec copy -an $silence';
    await _flutterFFmpeg.execute(command0);
    String command =
        '  -y -i $silence  -t 4 -i $audiopath -vcodec copy  $videopath';
    print('混入音乐的命令是：' + command);
    _flutterFFmpeg
        .execute(command)
        .then((value) => Toast.show("第${videoList.lengthIs()}幕已加入音乐"));
  }

  saveFile() async {
    // Directory directory = await getExternalStorageDirectory();
    // String path = directory.path;
    // String id = Uuid().v4().toString();
    // String fileName = p.join(path, '$id.mp4');
    // print(fileName);
    // var contents = await videoFile.readAsBytes();
    // File file2 = new File(fileName);
    // file2.writeAsBytes(contents).then((value) {
    //   uploadFile = value;
    //   upload();
    // });
    // saveSonFile();
    Directory directory = await getExternalStorageDirectory();
    String path = directory.path;
    File f = File('$path/output.mp4');
    if (f.existsSync()) {
      f.deleteSync();
    }
    videoList.printList();
    final file = new File('$path/filelist.txt');
    file.writeAsString('');
    IOSink slink = file.openWrite(mode: FileMode.append);
    for (int i = 1; i <= videoList.length; i++) {
      slink.write('file $i.mp4\n');
    }
    slink.close();
    String command =
        "-f concat -i $path/filelist.txt  -c copy $path/output.mp4";
    Toast.show('请稍等一段时间，正在合成视频');

    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    await _flutterFFmpeg.execute(command).then((rc) {
      print("FFmpeg process exited with rc $rc");
    });
    Timer(Duration(milliseconds: 800), () {});
    command =
        "-y -i $path/output.mp4 -t 32 -i $path/music.m4a -vcodec copy $path/output1.mp4";
    await _flutterFFmpeg.execute(command).then((value) {
      print("FFmpeg process exited with rc $value");
    });
    Timer(Duration(milliseconds: 800), () {
      uploadFile = new File("$path/output1.mp4");
      upload();
    });

    //合成视频
  }

  saveSonFile() async {
    Directory directory = await getExternalStorageDirectory();
    String path = directory.path;
    print(path);
    String fileName = p.join(path, "${videoList.lengthIs() + 1}.mp4");
    var contents = await videoFile.readAsBytes();
    File file = new File(fileName);
    file.writeAsBytes(contents).then((value) {
      setState(() {
        videoList.addToList(file);
      });
      Toast.show("第${videoList.lengthIs()}幕已保存");
      position++;
      getData();
      file = null;
    });
  }

  Future<void> upload() async {
    uriList.clear();
    if (uploadFile == null) {
      print('还没拍摄视频噢');
      return;
    }
    uriList.add(uploadFile.path);
    await myChannel.invokeMethod('douyin', {'uri': uriList});
  }

  changeCamera() {
    Toast.show('暂时不支持前后摄像头视频合成，合成的视频可能会出问题哦');
    if (curCamera == 0) {
      curCamera = 1;
    } else {
      curCamera = 0;
    }

    _cameracontroller = CameraController(
        cameras[curCamera], ResolutionPreset.high,
        enableAudio: true);
    _cameracontroller.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getCameras();
    videoList = new videoFileList(widget.video0.filter);
    rpx = widget.rpx;
    toTop = 100 * rpx;
    outBox = 170 * rpx;
    innerBox = 130 * rpx;

    getData();

    // videoBean v1 = new videoBean(
    //     1, 'assets/images/eggCover/1.png', '请使用后置摄像头拍摄，景色处于虚线框位置，镜头转动拍摄四周景色。');
    // videoBean v2 = new videoBean(2, 'assets/images/eggCover/2.png',
    //     '女人戴草帽，提⽵篓，⾯带微笑，喜⽓洋洋地在田野上从镜头左边走到右边，直到走出镜头。');
    // videoBean v3 = new videoBean(3, 'assets/images/eggCover/3.png',
    //     '镜头固定，扛着锄头的男人和戴草帽的女人一起走到屏幕中间，然后开始说台词。');
    // videoBean v4 = new videoBean(4, 'assets/images/eggCover/4.png',
    //     '请使用后置摄像头拍摄，动物和景色处于虚线框位置，镜头转动拍摄所有的鸡。',
    //     audio: 'chicktalk.wav');
    // videoBean v5 = new videoBean(5, 'assets/images/eggCover/5.png',
    //     '请使用后置摄像头拍摄，人物和景色处于虚线框位置，镜头固定。女人在鸡群里寻找否有鸡蛋。',
    //     audio: 'womanchick.wav');
    // videoBean v6 = new videoBean(6, 'assets/images/eggCover/6.png',
    //     '请使用后置摄像头拍摄，人物和景色处于虚线框位置，镜头固定。女人从鸡窝里面捡起三个沾着泥⼟的鸡蛋。');
    // videoBean v7 = new videoBean(7, 'assets/images/eggCover/7.png',
    //     '请使用后置摄像头拍摄，人物处于虚线框位置，镜头固定。农家妇⼥淳朴的笑容');
    // videoBean v8 = new videoBean(8, 'assets/images/eggCover/8.png',
    //     '请使用后置摄像头拍摄，人物处于虚线框位置，镜头固定。农家妇⼥用⼿将鸡蛋打破，鸡蛋流到碗里。');
    // videoBean v9 = new videoBean(9, '', '');
    //
    // // ttsWebsocket().initWebSocket(v1.script);
    //
    // setState(() {
    //   videoBeanList = [v1, v2, v3, v4, v5, v6, v7, v8, v9];
    // });
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   final CameraController cameraController = _cameracontroller;
  //
  //   // App state changed before we got the chance to initialize.
  //   if (cameraController == null || !cameraController.value.isInitialized) {
  //     return;
  //   }
  //
  //   if (state == AppLifecycleState.inactive) {
  //     cameraController.dispose();
  //   } else if (state == AppLifecycleState.resumed) {
  //     onNewCameraSelected(cameraController.description);
  //   }
  // }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (_cameracontroller != null) {
      await _cameracontroller.dispose();
    }
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: true,
      // imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _cameracontroller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) setState(() {});
      if (cameraController.value.hasError) {
        print('Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      // await Future.wait([
      //   cameraController
      //       .getMinExposureOffset()
      //       .then((value) => _minAvailableExposureOffset = value),
      //   cameraController
      //       .getMaxExposureOffset()
      //       .then((value) => _maxAvailableExposureOffset = value),
      //   cameraController
      //       .getMaxZoomLevel()
      //       .then((value) => _maxAvailableZoom = value),
      //   cameraController
      //       .getMinZoomLevel()
      //       .then((value) => _minAvailableZoom = value),
      // ]);
    } on CameraException catch (e) {
      // _showCameraException(e);
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _cameracontroller?.dispose();
    videoController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return Stack(
      children: [
        Container(
          child: FutureBuilder(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final xScale =
                    _cameracontroller.value.aspectRatio / deviceRatio;
                print(xScale);
                final yScale = 1.0;
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: CameraPreview(_cameracontroller),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child:
              Image.network(cur.boardUrl?? ''),
        ),
        Positioned(
          //顶部关闭按钮
          top: 80 * rpx + 20,
          left: 30 * rpx,
          child: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white60,
              size: 40,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Positioned(
          right: 30 * rpx,
          top: 80 * rpx + 80,
          child: IconButton(
              icon: Icon(Icons.wb_incandescent),
              iconSize: 40,
              color: Colors.white60,
              onPressed: () {
                setState(() {
                  offstage = !offstage;
                });
              }),
        ),
        Positioned(
            right: (MediaQuery.of(context).size.width - 280) / 2,
            top: 170,
            child: Offstage(
              offstage: offstage,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                    color: Colors.white,
                    // border:Border.all(color: Colors.blue, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white70,
                          // offset: Offset(-10,-10),
                          blurRadius: 2,
                          spreadRadius: 2),
                      BoxShadow(
                          color: Colors.white30,
                          // offset: Offset(-10,-10),
                          blurRadius: 1,
                          spreadRadius: 1),
                    ]),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      color: Colors.white,
                      //,strutStyle: StrutStyle(fontSize:18,height:1.2,leading: 0.5),
                      child: Text("剧本",
                          style: TextStyle(fontSize: 22.0, color: Colors.blue)),
                    ),
                    Container(
                      height: 2,
                      width: 50,
                      color: Colors.blue,
                    ),
                    Container(
                      height: 178,
                      padding: EdgeInsets.only(
                          top: 16, right: 16, left: 16, bottom: 16),
                      color: Colors.white,
                      child: Text(
                        cur.words ?? '',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Container(
                      // alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      // color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  ttsWebsocket().initWebSocket(
                                      cur.words);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(top: 4, bottom: 6),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "朗读",
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.blue),
                                  ),
                                ),
                              )),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  offstage = !offstage;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 4, bottom: 6),
                                alignment: Alignment.center,
                                child: Text(
                                  "取消",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
        Positioned(
          //拍照按钮
          bottom: 140 * rpx,
          // left: (750*rpx-outBox)/2,
          child: Container(
              width: 750 * rpx,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _thumbnailWidget(),
                    ),
                    Expanded(
                      flex: 2,
                      child: AnimVideoButton(
                        rpx: rpx,
                        outWidth: outBox,
                        innerWidth: innerBox - 30 * rpx,
                        cameraController: _cameracontroller,
                        callback: (f, c) {
                          setState(() {
                            videoFile = f;
                            print(f.path);
                            _startVideoPlayer();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        iconSize: 32,
                        icon: const Icon(Icons.close),
                        color: Colors.blue,
                        onPressed: () {
                          if(position == videoList.lengthIs()+1){
                            Toast.show("第${videoList.lengthIs()}幕已移除，请重新拍摄");
                            videoList.removeLastList();
                            position--;
                            getData();
                          }

                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      //
                      child: videoList.fullList()
                          ? IconButton(
                              iconSize: 50,
                              icon: const Icon(Icons.arrow_forward_outlined),
                              color: Colors.blue,
                              onPressed: () {
                                saveFile();
                              },
                            )
                          : IconButton(
                              iconSize: 40,
                              icon: const Icon(Icons.done),
                              color: Colors.blue,
                              onPressed: () {
                                saveSonFile();
                              },
                            ),
                    ),
                  ])),
        ),
        Positioned(
          right: 30 * rpx,
          top: 80 * rpx + 20,
          child: IconButton(
              icon: Icon(Icons.camera_front),
              iconSize: 40,
              color: Colors.white60,
              onPressed: () {
                changeCamera();
              }),
        ),
      ],
    );
  }

  Future<void> _startVideoPlayer() async {
    if (videoFile == null) {
      return;
    }
    videoController = null;

    final VideoPlayerController vController =
        VideoPlayerController.file(File(videoFile.path));
    // videoPlayerListener = () {
    //   if (videoController != null && videoController!.value.size != null) {
    //     // Refreshing the state to update video player with the correct ratio.
    //     if (mounted) setState(() {});
    //     videoController!.removeListener(videoPlayerListener!);
    //   }
    // };
    // vController.addListener(videoPlayerListener!);
    // await vController.setLooping(true);
    await vController.initialize();
    // await videoController.pause();
    // videoController = null;
    if (mounted) {
      setState(() {
        imageFile = null;
        videoController = vController;
      });
    }
    // await vController.play();
  }

  Widget _thumbnailWidget() {
    final VideoPlayerController localVideoController = videoController;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            new CupertinoPageRoute<void>(
                builder: (ctx) => VideoPage(
                      filePath: videoFile.path,
                    )));
      },
      child: Container(
        // margin: EdgeInsets.only(right: 20),
        child: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              localVideoController == null && imageFile == null
                  ? Container(
                      child: SizedBox(
                        width: 64.0,
                        height: 64.0,
                      ),
                    )
                  : SizedBox(
                      child: (localVideoController == null)
                          ? Image.file(File(imageFile?.path))
                          : Container(
                              child: Center(
                                child: AspectRatio(
                                    aspectRatio:
                                        localVideoController.value.size != null
                                            ? localVideoController
                                                .value.aspectRatio
                                            : 1.0,
                                    child: VideoPlayer(localVideoController)),
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue)),
                            ),
                      width: 64.0,
                      height: 64.0,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScrollBottomBar extends StatefulWidget {
  ScrollBottomBar({Key key, @required this.rpx}) : super(key: key);
  final double rpx;

  _ScrollBottomBarState createState() => _ScrollBottomBarState();
}

class _ScrollBottomBarState extends State<ScrollBottomBar> {
  double rpx;
  double eachWidth;
  double eachSide;
  List<String> items;
  ScrollController controller;
  double startX = 0;
  double finalX = 0;
  double minValue;
  double maxValue;
  double curX;
  int curIndex;

  @override
  void initState() {
    super.initState();
    rpx = widget.rpx;
    eachWidth = 130 * rpx;
    eachSide = (750 - eachWidth / rpx) / 2 * rpx;
    curIndex = 2;
    minValue = 0;

    items = [
      '拍照',
      '拍15秒',
      '拍60秒',
      '影集',
      '开直播',
    ];
    maxValue = (items.length - 1) * eachWidth;
    curX = curIndex * eachWidth;
    controller = ScrollController(initialScrollOffset: curX);
  }

  moveToItem(index) {
    curX = index * eachWidth;
    controller.animateTo(curX,
        duration: Duration(milliseconds: 200), curve: Curves.linear);
    setState(() {
      curX = curX;
      curIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Listener(
        onPointerDown: (result) {
          setState(() {
            startX = result.position.dx;
          });
        },
        onPointerMove: (result) {
          double moveValue = result.position.dx;
          double moved = startX - moveValue;
          // curX+moved
          double afterMoved = min(max(curX + moved, minValue), maxValue);
          setState(() {
            curX = afterMoved;
            startX = result.position.dx;
          });
        },
        onPointerUp: (result) {
          int index = 0;
          double finalPosition = curX - eachWidth / 2;
          index = (finalPosition / eachWidth).ceil();
          moveToItem(index);
        },
        child: Container(
            width: 750 * rpx,
            height: 100 * rpx,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: controller,
              child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: eachSide,
                    ),
                    Row(
                        children: List.generate(items.length, (index) {
                      return Container(
                        width: eachWidth,
                        child: FlatButton(
                          child: Text(
                            items[index],
                            style: TextStyle(
                                color: curIndex == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5)),
                          ),
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            moveToItem(index);
                          },
                        ),
                      );
                    })),
                    SizedBox(
                      width: eachSide,
                    ),
                  ],
                ),
              ),
            )),
      ),
      Center(
        child: Container(
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          width: 8 * rpx,
          height: 8 * rpx,
        ),
      )
    ]);
  }
}

class AnimVideoButton extends StatefulWidget {
  AnimVideoButton(
      {Key key,
      this.callback,
      @required this.outWidth,
      @required this.innerWidth,
      @required this.rpx,
      @required this.cameraController})
      : super(key: key);
  final double outWidth;
  final double innerWidth;
  final double rpx;
  final CameraController cameraController;
  _CallBack callback;

  _AnimVideoButtonState createState() => _AnimVideoButtonState();
}

class _AnimVideoButtonState extends State<AnimVideoButton>
    with TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  double outWidth;
  double innerWidth;
  double outBorder;
  double rpx;
  double maxBorder;
  bool ifRecording;

  // CameraProvider provider;
  CameraController cameraController;
  double curBorder;

  String fileName;

  // _CallBack _callBack;

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    cameraController?.dispose();
    super.dispose();
  }

  saveFile(File file) async {
    Directory directory = await getExternalStorageDirectory();
    String path = directory.path;
    String id = Uuid().v4().toString();
    fileName = p.join(path, '$id.mp4');
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> startVideoRecording() async {
    final CameraController cameraController = widget.cameraController;
    print("视频录制开始--------------------------------------------------");

    if (cameraController == null || !cameraController.value.isInitialized) {
      print('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await cameraController.startVideoRecording();
    } on CameraException catch (e) {
      print(e);
      return;
    }
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((file) {
      if (mounted) setState(() {});
      if (file != null) {
        setState(() {
          if (widget.callback != null) {
            widget.callback(file, null);
          }
        });
        // _startVideoPlayer();
      }
    });
  }

  Future<XFile> stopVideoRecording() async {
    final CameraController cameraController = widget.cameraController;
    print("视频录制结束--------------------------------------------------");

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      print('出现了问题是' + e.toString());
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    ifRecording = false;
    // provider = widget.provider;
    cameraController = widget.cameraController;
    outWidth = widget.outWidth;
    innerWidth = widget.innerWidth;
    rpx = widget.rpx;
    outBorder = 5 * rpx;
    maxBorder = (outWidth - innerWidth) / 2 - 10 * rpx;
    curBorder = outBorder;
    controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation =
        Tween<double>(begin: outBorder, end: maxBorder).animate(controller)
          ..addListener(() {
            setState(() {
              curBorder = animation.value;
            });
          });
    controller.repeat(reverse: true);
  }

  pauseRecording() {
    // provider.cameraController.pauseVideoRecording();
    controller.stop();
    // provider.cameraController.pauseVideoRecording();
    // provider.cameraController
    setState(() {
      ifRecording = false;
    });
  }

  resumeRecording() {
    // provider.cameraController.resumeVideoRecording();
    controller.repeat(reverse: true);
    // provider.cameraController.resumeVideoRecording();
    setState(() {
      ifRecording = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: outWidth,
      height: outWidth,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(width: curBorder, color: Colors.lightBlueAccent)),
      child: Container(
        child: !ifRecording
            ? IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.play_arrow,
                  size: innerWidth,
                  color: Colors.blue,
                ),
                onPressed: () {
                  resumeRecording();
                  onVideoRecordButtonPressed();
                },
              )
            : IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.pause,
                  size: innerWidth,
                  color: Colors.blue,
                ),
                onPressed: () {
                  pauseRecording();
                  onStopButtonPressed();
                },
              ),
      ),
    );
  }
}
