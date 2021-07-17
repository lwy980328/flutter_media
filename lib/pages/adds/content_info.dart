import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'dart:io';


import 'package:flutter_media/pages/adds/video_0_bean.dart';


// import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';


// import 'package:webview_flutter/webview_flutter.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'CameraPage.dart';
import 'html_bean.dart';
import 'Camera.dart';

import 'package:flutter_media/pages/adds/videoMarket.dart';
import 'package:flutter_media/pages/adds/htmlMarket.dart';
import 'htmlMarketContro.dart';


MethodChannel myChannel = const MethodChannel('flutter_plugin');

class ContentInfoPage extends StatefulWidget {
  htmlbean data;
  video0bean video0;

  ContentInfoPage(this.data,this.video0);

  @override
  _ContentInfoPageState createState() => _ContentInfoPageState();
}

class _ContentInfoPageState extends State<ContentInfoPage>
    with TickerProviderStateMixin {

  List tabText = ['营销视频', '营销图文'];
  TabController _tabController;
  String content = '';

  List<String> uriList = List();
  List<AssetEntity> assets;
  int index = 0;

  htmlMarketController h;


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

    h = new htmlMarketController(widget.data);
    super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }



  // _pickVideo() async {
  //   // PickedFile _video = await ImagePicker().getVideo(source: ImageSource.gallery);
  //   String DCIMpath = '';
  //   getExternalStorageDirectories(type: StorageDirectory.alarms).then((value) {
  //     DCIMpath = value.toString();
  //     print(DCIMpath);
  //   });
  //
  //   FilePickerResult result = await FilePicker.platform.pickFiles();
  //   uriList.add(result.files.single.path);
  //
  // }

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
            onTap: (){
              setState(() {
                h = new htmlMarketController(widget.data);
              });
            },
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Center(
                child: Text('换一个'),
              ),
            ),
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
                  VideoMarket(widget.video0),
                  HtmlMarket(h),
                  // html(),
                  // sellVideo(),
                ],
              ),
            ),
            // Offstage(
            //   offstage: index != 0,
            //   child: Padding(
            //     padding: EdgeInsets.only(
            //       bottom: 16,
            //       top: 6,
            //     ),
            //     child: Center(
            //       child: CupertinoButton(
            //         borderRadius: BorderRadius.circular(40),
            //         onPressed: () {
            //           // Navigator.of(context).pushNamedAndRemoveUntil('/camera', ModalRoute.withName('/homepage'));
            //           // Navigator.pushNamedAndRemoveUntil(context, "/camera",ModalRoute.withName("/camera"));
            //           // Navigator.popUntil(context, ModalRoute.withName('/home'));
            //           Navigator.of(context)
            //               .push(new MaterialPageRoute(builder: (context) {
            //             return new Camera();
            //           }));
            //         },
            //         color: Colors.blue,
            //         child: Text('拍这个'),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
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


}


