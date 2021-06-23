import 'package:camera/camera.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_html/shims/dart_ui.dart';
import 'package:flutter_media/pages/adds/videoFileList.dart';
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
import 'package:flutter_tts/flutter_tts.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CameraMain(
        rpx: MediaQuery.of(context).size.width / 750,
      ),
      bottomNavigationBar: BottomAppBar(),
    );
  }
}

typedef _CallBack = void Function(XFile file);


class CameraMain extends StatefulWidget {
  final double rpx;

  CameraMain({Key key, @required this.rpx}) : super(key: key);

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
  FlutterTts flutterTts = FlutterTts();


  String testStr = '我是一个大好人';

  // CameraProvider cameraProvider ;

  int curCamera = 1;

  getCameras() async {
    _cameracontroller = CameraController(cameras[curCamera], ResolutionPreset.high,
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
    if(f.existsSync()){
      f.deleteSync();
    }
    videoList.printList();

    final file = new File('$path/filelist.txt');
    file.writeAsString('');
    IOSink slink = file.openWrite(mode: FileMode.append);
    for(int i=1;i<=videoList.length;i++){
      slink.write('file $i.mp4\n');
    }
    slink.close();
    String command = " -f concat -i $path/filelist.txt  -c copy $path/output.mp4";
    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    _flutterFFmpeg
        .execute(command)
        .then((rc) {
      print("FFmpeg process exited with rc $rc");
      uploadFile = new File("$path/output.mp4");
      upload();
    } );

    //合成视频
  }

  saveSonFile() async{
    Directory directory = await getExternalStorageDirectory();
    String path = directory.path;
    print(path);
    String fileName = p.join(path, "${videoList.lengthIs()+1}.mp4");
    var contents = await videoFile.readAsBytes();
    File file = new File(fileName);
    file.writeAsBytes(contents).then((value) {
      setState(() {
        videoList.addToList(file);
      });
      Toast.show("第${videoList.lengthIs()}幕已保存");
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

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> startVideoRecording() async {
    final CameraController cameraController = _cameracontroller;
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
        print('Video recorded to ${file.path}');
        videoFile = file;
        // _startVideoPlayer();
      }
    });
  }

  Future<XFile> stopVideoRecording() async {
    final CameraController cameraController = _cameracontroller;
    print("视频录制结束--------------------------------------------------");

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      print(e);
      return null;
    }
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) setState(() {});
      print('Video recording paused');
    });
  }

  Future<void> pauseVideoRecording() async {
    final CameraController cameraController = _cameracontroller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      await cameraController.pauseVideoRecording();
    } on CameraException catch (e) {
      print(e);
      rethrow;
    }
  }

  changeCamera() {
    if (curCamera == 0) {
      curCamera = 1;
    } else {
      curCamera = 0;
    }
    _cameracontroller = CameraController(cameras[curCamera], ResolutionPreset.max);
    _cameracontroller.initialize().then((_) {
      setState(() {});
    });
  }

  void showAlertDialog() {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('剧本'),
            //可滑动
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text('内容 1'),

                ],
              ),
            ),
            actions: <Widget>[
              Expanded(
                flex: 1,
                child: new FlatButton(
                  child: new Text('朗读'),
                  onPressed: () {
                    // Navigator.of(context).pop();
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: new FlatButton(
                  child: new Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getCameras();
    videoList = new videoFileList(8);
    rpx = widget.rpx;
    toTop = 100 * rpx;
    outBox = 170 * rpx;
    innerBox = 130 * rpx;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // final CameraController cameraController = _cameracontroller;
    //
    // // App state changed before we got the chance to initialize.
    // if (cameraController == null || !cameraController.value.isInitialized) {
    //   return;
    // }
    //
    // if (state == AppLifecycleState.inactive) {
    //   cameraController.dispose();
    // } else if (state == AppLifecycleState.resumed) {
    //   onNewCameraSelected(cameraController.description);
    // }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (_cameracontroller != null) {
      await _cameracontroller.dispose();
    }
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: true,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _cameracontroller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) setState(() {});
      if (cameraController.value.hasError) {
        print(
            'Camera error ${cameraController.value.errorDescription}');
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
    // provider = Provider.of<CameraProvider>(context);
    // _controller=provider.cameraController;
    // if (provider == null || _controller == null) {
    //   return Container(
    //     child: Center(child: CircularProgressIndicator()),
    //   );
    // }
    // bool ifMakeVideo = provider.ifMakeVideo;
    // if (_controller == null || _controller?.value == null) {
    //   return Container(
    //     child: Center(child: CircularProgressIndicator()),
    //   );
    // }
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    // final deviceRatio = size.height / size.width;

    return Stack(
      children: [
        Container(
          child: FutureBuilder(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final xScale = _cameracontroller.value.aspectRatio / deviceRatio;
                print(xScale);
                final yScale = 1.0;
                // return Container(
                //   // child: CameraPreview(_controller),
                //   child: Transform.scale(
                //     scale: _controller.value.aspectRatio/deviceRatio,
                //     child: Center(
                //       child: AspectRatio(
                //         aspectRatio: _controller.value.aspectRatio,
                //         child: CameraPreview(_controller),
                //       ),
                //     ),
                //   ),
                //   // width: MediaQuery.of(context).size.width,
                //   // height: MediaQuery.of(context).size.height,
                // );
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
          child: Image.asset('assets/images/mengban.png'),
        ),
        Positioned(
          //顶部关闭按钮
          top: 80 * rpx + 20,
          left: 30 * rpx,
          child: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white60,
              size: 60 * rpx,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        // Positioned(
        //   //选择音乐
        //   top: toTop,
        //   left: 250 * rpx,
        //   child: Container(
        //     width: 250 * rpx,
        //     child: FlatButton(
        //       onPressed: () {},
        //       child: Row(
        //         children: <Widget>[
        //           Icon(
        //             Icons.music_note,
        //             color: Colors.white,
        //           ),
        //           SizedBox(
        //             width: 10 * rpx,
        //           ),
        //           Text(
        //             "选择音乐",
        //             style: TextStyle(color: Colors.white),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
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
                        flex:2,
                        child: _thumbnailWidget(),
                    ),
                    Expanded(
                      flex:2,
                      child: AnimVideoButton(
                        rpx: rpx,
                        outWidth: outBox,
                        innerWidth: innerBox - 30 * rpx,
                        cameraController: _cameracontroller,
                        callback: (f) {
                          setState(() {
                            videoFile = f;
                            print(f.path);
                            _startVideoPlayer();
                          });
                        },
                      ),
                    ), Expanded(
                      flex: 1,
                      child: IconButton(
                        iconSize: 32,
                        icon: const Icon(Icons.close),
                        color: Colors.blue,
                        onPressed: () {
                          videoList.removeLastList();
                          Toast.show("第${videoList.lengthIs()}幕已移除，请重新拍摄");
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: videoList.fullList()
                          ? IconButton(
                              iconSize: 40,
                              icon: const Icon(Icons.done),
                              color: Colors.blue,
                              onPressed: (){
                                saveFile();
                              },
                            )
                          : IconButton(
                              iconSize: 50,
                              icon: const Icon(Icons.navigate_next_outlined),
                              color: Colors.blue,
                              onPressed: () {
                                saveSonFile();
                              },
                            ),
                    ),
                  ])),
        ),
        // Positioned(
        //   bottom: 40 * rpx,
        //   child: ScrollBottomBar(
        //     rpx: rpx,
        //   ),
        // ),
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
        Positioned(
          right: 30 * rpx,
          top: 80 * rpx + 80,
          child: IconButton(
              icon: Icon(Icons.wb_incandescent),
              iconSize: 40,
              color: Colors.white60,
              onPressed: () {
                showAlertDialog();
              }),
        )
      ],
    );
  }

  Future<void> _startVideoPlayer() async {

    if (videoFile == null) {
      return;
    }

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
    videoController = null;
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
  XFile videoFile;
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
        print('Video recorded to ${file.path}');
        videoFile = file;
        setState(() {
          if (widget.callback != null) {
            widget.callback(file);
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
      print(e);
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
