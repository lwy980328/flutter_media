
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterspeechrecognizerifly/flutterspeechrecognizerifly.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'complete_info.dart';

class StartProductPage extends StatefulWidget {
  @override
  _StartProductPageState createState() => _StartProductPageState();
}

class _StartProductPageState extends State<StartProductPage> {
  //输入相关
  FocusNode _focusNode = FocusNode();
  String inputText = '';

  //语音识别相关
  final Flutterspeechrecognizerifly ifly = Flutterspeechrecognizerifly();
  String _platformVersion = 'Unknown';
  String _recgonizerRet1 = "";

  //拍照
  File _img;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
    init();
  }




  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await ifly.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  init() async {
    var ret = await ifly.init("5ed77343");
    print(ret);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("开始营销传作"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // SizedBox(height: 30,),
                  TextWidget(),
                  // SizedBox(height: 30,),
                  // VoiceWidget(),
                  // SizedBox(height: 30,),
                  PhotoWidget(),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CupertinoButton(
                borderRadius: BorderRadius.circular(40),
                onPressed: () {
                  _focusNode.unfocus();
                  Navigator.push(
                      context,
                      new CupertinoPageRoute<void>(
                          builder: (ctx) => CompleteInfoPage()));
                },
                color: Colors.blue,
                child: Text('下一步'),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget TextWidget() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.only(left: 16,right: 16,top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '请告诉我您想做什么',
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
          SizedBox(
            height: 12,
            width: MediaQuery.of(context).size.width,
          ),
          Text(
            '比如“卖鸡蛋”',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            height: 40,
            width: 240,
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: TextField(
              focusNode: _focusNode,
              controller: TextEditingController.fromValue(TextEditingValue(
                  text: inputText,
                  selection: TextSelection.fromPosition(TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: inputText.length)))),
              onChanged: (val) {
                setState(() {
                  inputText = val;
                });
              },
              maxLines: 1,
              maxLength: 10,
              //限制汉字
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp("[\u4e00-\u9fa5]"))
              ],
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 6,right: 6,bottom: 8,),
                  counterText: '',
                  // counterStyle:
                  //     TextStyle(fontSize: 10, color: Color(0xFF697373)),
                  border: InputBorder.none),
              style: TextStyle(fontSize: 16, height: 24 / 16),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            // padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '您也可以说给我',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
                SizedBox(
                  height: 12,
                ),
                // Row(
                //   children: [
                //     Expanded(flex: 1, child: Container()),
                //     Expanded(
                //         flex: 1,
                //         child: Text(
                //           "识别为：$_recgonizerRet1",
                //           style:
                //               TextStyle(fontSize: 12, color: Color(0xFF697373)),
                //         )),
                //     IconButton(
                //         icon: Icon(Icons.delete),
                //         onPressed: () {
                //           setState(() {
                //             _recgonizerRet1 = '';
                //           });
                //         })
                //   ],
                // ),
                // Text("识别为：$_recgonizerRet1",style: TextStyle(fontSize: 12,color: Color(0xFF697373)),),
                IconButton(
                  icon: Image.asset('assets/images/listen.png'),
                  iconSize: 80,
                  onPressed: () async {
                    ifly.start((Map<String, dynamic> message) async {
                      print("flutter onOpenNotification: $message");
                      setState(() {
                        inputText += message["text"];
                      });
                    }, useView: true);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget VoiceWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      // padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '您也可以说给我',
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Expanded(flex: 1, child: Container()),
              Expanded(
                  flex: 1,
                  child: Text(
                    "识别为：$_recgonizerRet1",
                    style: TextStyle(fontSize: 12, color: Color(0xFF697373)),
                  )),
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _recgonizerRet1 = '';
                    });
                  })
            ],
          ),
          // Text("识别为：$_recgonizerRet1",style: TextStyle(fontSize: 12,color: Color(0xFF697373)),),
          IconButton(
            icon: Image.asset('src/picture/listen.png'),
            iconSize: 50,
            onPressed: () async {
              ifly.start((Map<String, dynamic> message) async {
                print("flutter onOpenNotification: $message");
                setState(() {
                  _recgonizerRet1 += message["text"];
                });
              }, useView: true);
            },
          )
        ],
      ),
    );
  }

  Widget PhotoWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      // padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '或者你也可以拍给我',
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
          SizedBox(
            height: 12,
            width: MediaQuery.of(context).size.width,
          ),
          Offstage(
            offstage: _img == null,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Stack(
                children: [
                  Container(
                    // height: 150,
                    // width: 150,
                    child: _imageView(_img),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _img = null;
                      });
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 134, top: 2),
                        child: Icon(Icons.delete)),
                  )
                ],
              ),
            ),
          ),
          IconButton(
            icon: Image.asset('assets/images/shot.png'),
            iconSize: 80,
            onPressed: () async {
              var image =
                  await ImagePicker().getImage(source: ImageSource.camera);
              // var image = await ImagePicker.pickImage(source: ImageSource.camera);
              setState(() {
                if (image != null) {
                  _img = File(image.path);
                } else {
                  print('没有选中图片');
                }
              });
            },
          )
        ],
      ),
    );
  }

  Widget _imageView(var imgPath) {
    if (imgPath == null) {
      return Center(
        child: Text("图片"),
      );
    } else {
      return Image.file(
        imgPath,
      );
    }
  }
}
