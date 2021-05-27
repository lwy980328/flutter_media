import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;

// import 'package:farmers_lead_app/CameraMain.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'CameraPage.dart';
import 'html_bean.dart';

MethodChannel myChannel = const MethodChannel('flutter_plugin');

class ContentInfoPage extends StatefulWidget {
  htmlbean data;

  ContentInfoPage(this.data);

  @override
  _ContentInfoPageState createState() => _ContentInfoPageState();
}

class _ContentInfoPageState extends State<ContentInfoPage>
    with TickerProviderStateMixin {
  List tabText = ['营销图文', '营销视频', '拍摄脚本', '网点布局'];
  TabController _tabController;
  VideoPlayerController _videoPlayerController;
  String content = '';
  WebViewController webViewController;

  // Completer<WebViewController> _ccontro = Completer<WebViewController>();
  String get = '';

  List<String> uriList = List();
  List<AssetEntity> assets;
  int index = 0;

  String htmldata = '';

  @override
  void initState() {
    // TODO: implement initState
    _tabController =
        TabController(length: tabText.length, vsync: this, initialIndex: 0)
          ..addListener(() {
            setState(() {
              index = _tabController.index;
            });
          });
    _videoPlayerController = VideoPlayerController.asset(
      'assets/video/eggVideo.mp4',
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _videoPlayerController.addListener(() {
      setState(() {});
    });
    _videoPlayerController.setLooping(true);
    _videoPlayerController.initialize().then((_) => setState(() {}));
    // _videoPlayerController.play();

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    // readHtml();
    getData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  // Future<String> _getFile() async {
  //   return await rootBundle.loadString('src/html/demo.html');
  //

  readHtml() async {
    htmldata = await rootBundle.loadString('assets/html/demo.html');
    print(htmldata);
  }

  Future<void> test() async {
    get = await myChannel.invokeMethod('douyin', {'uri': uriList});
    print(get);
  }

  _pickVideo() async {
    // PickedFile _video = await ImagePicker().getVideo(source: ImageSource.gallery);
    String DCIMpath = '';
    getExternalStorageDirectories(type: StorageDirectory.alarms).then((value) {
      DCIMpath = value.toString();
      print(DCIMpath);
    });

    FilePickerResult result = await FilePicker.platform.pickFiles();
    uriList.add(result.files.single.path);
    // uriList.add(_video.path.);
    // print(file.absolute.path);
    // uriList.add(file.path);
    // print(uriList);
  }

  getData() async {
    var i = {
      '名称': '海淀鸡蛋',
      '产地': '北京市海淀区',
      '特色': '好吃',
      '关键词': '鸡蛋',
      '联系方式':'小明',
    };
      var k =   {
      '名称': widget.data.name,
      '产地': widget.data.productplace,
      '特色': widget.data.character.toString(),
      '关键词': widget.data.keyword,
      '联系方式':'小明',
    };

    var j = convert.jsonEncode(k);


    // var httpClient = new HttpClient();
    // var uri = new Uri.http(
    //     '39.105.219.200:18080', '/temController/articleComposition',
    // //     {
    // //   '名称': widget.data.name,
    // //   '产地': widget.data.productplace,
    // //   '特色': widget.data.character,
    // //   '关键字': widget.data.keyword,
    // //   '联系方式':'小明',
    // // }
    //     {
    //     '名称': '海淀鸡蛋',
    //     '产地': '北京市海淀区',
    //     '特色': '好吃',
    //     '关键字': '鸡蛋',
    //     '联系方式':'小明',
    //     }
    // );
    // print(uri);
    // var request = await httpClient.postUrl(uri);
    // var response = await request.close();
    // var responseBody = await response.transform(utf8.decoder).join();

        // {'名称': widget.data.name, '产地': widget.data.productplace,'特色': widget.data.character.toString(),'关键字': widget.data.keyword,'联系方式':'小明',}

    var url = Uri.parse('http://39.105.219.200:18080/temController/articleComposition');
    var response = await http.post(url, body: j);
    print(response.request);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if(response.statusCode == 200) {
      setState(() {
        htmldata = convert.jsonDecode(response.body)['data'];
      });
    }else if(response.statusCode == 500){
      getData();
    }
  }

  Future<void> selectAssets() async {
    final List<AssetEntity> result = await AssetPicker.pickAssets(
      context,
      requestType: RequestType.video,
      maxAssets: 1,
      pathThumbSize: 84,
      gridCount: 4,
      selectedAssets: assets,
    );
    if (result != null) {
      assets = List<AssetEntity>.from(result);
      print(assets.first);
      AssetEntity asset = assets.first;
      File file = await asset.file;
      print(file.path);
      uriList.add(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('选择内容形式'),
        backgroundColor: Colors.blue,
        actions: [
          GestureDetector(
            onTap: getData,
            child:Padding(
              padding: EdgeInsets.only(right: 10),
              child: Center(
                child: Text('换一个'),
              ),
            ) ,
          )

        ],
        bottom: TabBar(
          isScrollable: false,
          labelPadding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
          indicatorColor: Colors.blue,
          labelColor: Colors.white,
          controller: _tabController,
          tabs: tabText.map((e) => Text(e)).toList(),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  // sellGraphic(),
                  // Container(),
                  html(),
                  marketGraphic(),
                  // sellVideo(),
                  Container(),
                  Container()
                ],
              ),
            ),
            Offstage(
              offstage: index != 1,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: 16,
                  top: 6,
                ),
                child: Center(
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(40),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new CupertinoPageRoute<void>(
                              builder: (ctx) => CameraPage()));
                    },
                    color: Colors.blue,
                    child: Text('拍这个'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget html() {
    return SingleChildScrollView(
        child: Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),

      // margin: EdgeInsets.all(2.0),
      child: Html(
        data: htmldata,
        onImageError: (exception, stackTrace) {
          print("图片加载发生错误" + exception);
        },
        onImageTap: (src, _, __, ___) {
          print(src);
        },

        // customRender: {
        //   "h2": (context, child){
        //     return Text(content.characters.toString());
        //
        //   }
        //
        // },
      ),
    ));
  }

  // Widget sellGraphic(){
  //   return Container(
  //     child: SingleChildScrollView(
  //       child: FutureBuilder(
  //         future: _getFile(),
  //         builder: (context,snapshot){
  //           if (snapshot.hasData) {
  //             return WebView(
  //               javascriptMode: JavascriptMode.unrestricted,
  //               initialUrl: Uri.dataFromString(snapshot.data, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString(), // 加载的url
  //               onPageFinished: (String value) {
  //                 // webview 页面加载调用
  //               },
  //             );
  //           } else if (snapshot.hasError) {
  //             return Scaffold(
  //               body: Center(
  //                 child: Text("${snapshot.error}"),
  //               ),
  //             );
  //           }
  //           return Scaffold(
  //             body: Center(child: CircularProgressIndicator(),),
  //           );
  //         },
  //       )
  //     ),
  //   );
  // }

  // Widget sellGraphic(){
  //   return Scaffold(
  //     body: Container(
  //       child: WebView(
  //         initialUrl: '',
  //         javascriptMode: JavascriptMode.unrestricted,
  //         onWebViewCreated: (WebViewController w){
  //           webViewController =w;
  //           _getHTML();
  //         },
  //       ),
  //     )
  //   );
  // }
  //
  // _getHTML() async{
  //   String s = await rootBundle.loadString('src/html/demo.html');
  //   webViewController.loadUrl(Uri.dataFromString(s,mimeType: 'text/html',encoding: Encoding.getByName('utf-8')).toString());
  // }

  // Widget sellVideo(){
  //   return Container(
  //     padding: EdgeInsets.all(16),
  //     // margin: EdgeInsets.all(16),
  //     // padding: EdgeInsets.all(16),
  //     // decoration: BoxDecoration(
  //     //   color: Colors.white,
  //     //   borderRadius: BorderRadius.circular(12),
  //     // ),
  //     child: SingleChildScrollView(
  //       child: Column(
  //         children: [
  //           // Padding(
  //           //   padding: EdgeInsets.all(16),
  //           //   child: Center(
  //           //     child: CupertinoButton(
  //           //       borderRadius: BorderRadius.circular(40),
  //           //       onPressed: () {Navigator.push(context, new CupertinoPageRoute<void>(builder: (ctx) => CameraPage()));},
  //           //       color: Colors.blue,
  //           //       child: Text('拍这个'),
  //           //     ),
  //           //   ),
  //           // )
  //           // Padding(
  //           //   padding: EdgeInsets.all(16),
  //           //   child: Center(
  //           //     child: CupertinoButton(
  //           //       borderRadius: BorderRadius.circular(40),
  //           //       onPressed: () {test();},
  //           //       color: Colors.blue,
  //           //       child: Text('拍这个'),
  //           //     ),
  //           //   ),
  //           // )
  //         ],
  //       ),
  //     ),
  //
  //   );
  // }

  Widget marketGraphic() {
    return Container(
      padding: EdgeInsets.all(16),
      // margin: EdgeInsets.all(16),
      // padding: EdgeInsets.all(16),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(12),
      // ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Text('模板demo'),
            Container(
              padding: EdgeInsets.all(0),
              child: AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    VideoPlayer(_videoPlayerController),
                    // ClosedCaption(text: _videoPlayerController.value.caption.text,),
                    _ControlsOverlay(controller: _videoPlayerController),
                    VideoProgressIndicator(_videoPlayerController,
                        allowScrubbing: true)
                  ],
                ),
              ),
            ),
            // SizedBox(
            //   height: 20,
            // ),
            // Padding(
            //   padding: EdgeInsets.all(16),
            //   child: Center(
            //     child: CupertinoButton(
            //       borderRadius: BorderRadius.circular(40),
            //       onPressed: () {Navigator.push(context, new CupertinoPageRoute<void>(builder: (ctx) => CameraPage()));},
            //       color: Colors.blue,
            //       child: Text('拍这个'),
            //     ),
            //   ),
            // )
            // Padding(
            //   padding: EdgeInsets.all(16),
            //   child: Center(
            //     child: CupertinoButton(
            //       borderRadius: BorderRadius.circular(40),
            //       onPressed: () {selectAssets();},
            //       color: Colors.blue,
            //       child: Text('选视频'),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.all(16),
            //   child: Center(
            //     child: CupertinoButton(
            //       borderRadius: BorderRadius.circular(40),
            //       onPressed: () {test();},
            //       color: Colors.blue,
            //       child: Text('上传'),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key key, this.controller}) : super(key: key);

  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (context) {
              return [
                for (final speed in _examplePlaybackRates)
                  PopupMenuItem(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
