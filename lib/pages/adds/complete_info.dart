
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_media/pages/adds/video_0_bean.dart';
import 'package:flutter_media/pages/tts/ttswebsocket.dart';
import 'package:flutter_media/util/navigator_util.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:http/http.dart' as http;
import 'content_info.dart';
import 'html_bean.dart';
import 'dart:convert' as convert;
class CompleteInfoPage extends StatefulWidget {
  htmlbean data;
  CompleteInfoPage(this.data);
  @override
  _CompleteInfoPageState createState() => _CompleteInfoPageState();
}

class _CompleteInfoPageState extends State<CompleteInfoPage> {
  List<String> characterList = ['绿色', '有机', '无饲料', '健康', '个大', '营养'];
  List<bool> choosed = List.filled(6, false);

  String province = '';
  String city = '';
  String area = '';

  FocusNode focusNode = FocusNode();
  String inputText1 = '贵州省黔南布依族苗族自治州长顺县';

  FocusNode _focusNode = FocusNode();
  String inputText = '';

  video0bean video0;
  @override
  void initState() {
    // TODO: implement initState

    getVideoData();
    super.initState();

  }

  getVideoData() async{

    print('------------------------------');
    var options = BaseOptions(
      // responseType: ResponseType.plain,
      baseUrl: 'http://39.105.219.200:8089',
      method: 'GET',
      queryParameters: {'keywords':widget.data.keyword==''?'鸡蛋':widget.data.keyword}
      // contentType: 'multipart/form-data;boundary=<calculated when request is sent>',
    );

    var response = await Dio(options).request('/template/video/getByKeywordsRandom');
    print(response.realUri);


    print('Response status: ${response.statusCode}');
    print('Response body: ${response.data}');
    if (response.statusCode == 200) {
      setState(() {
        print(response.data['data']['id']);
        int id = response.data['data']['id'];
        String keywords = response.data['data']['keywords'];
        String videoUrl = response.data['data']['videoUrl'];
        int filter = response.data['data']['filter'];
        video0 = new video0bean(id??0, videoUrl??'', keywords??'', filter??0);
        print('------------------------------');

        // videourl = videoUrl;

      });
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    focusNode.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('完善产品信息'),
        backgroundColor: Colors.blue,

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [characterChoose(), productAreaChoose(), whatsName()],
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
                  focusNode.unfocus();
                  NavigatorUtil.pushReplacementNamed(context, ContentInfoPage(widget.data..productplace = inputText1..character = characterList..name = inputText,video0));
                  // Navigator.of(context).push(new MaterialPageRoute(builder: (context){return new ContentInfoPage(widget.data..productplace = inputText1..character = characterList..name = inputText);}));
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

  Widget characterChoose() {
    return Container(
      margin: EdgeInsets.only(right: 12, left: 12, top: 20, bottom: 20),
      padding: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '请选择产品特色',
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Container(
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: characterList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 4,
                      crossAxisCount: 3,
                      childAspectRatio: 2),
                  itemBuilder: (context, index) {
                    return Container(
                      height: 16,
                      padding: EdgeInsets.all(8),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        elevation: 0,
                        color: choosed[index] ? Colors.blue : Colors.white,
                        onPressed: () {
                          setState(() {
                            if (choosed[index] == false) {
                              choosed[index] = true;
                            } else {
                              choosed[index] = false;
                            }
                          });
                        },
                        // borderSide: BorderSide(
                        //   color: Colors.blue,
                        //   width: 2.0,
                        //   style: BorderStyle.solid
                        // ),
                        child: Text(
                          characterList[index],
                          style: TextStyle(
                              color:
                                  choosed[index] ? Colors.white : Colors.blue,
                              fontSize: 18),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget productAreaChoose() {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '请选择产地',
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  // padding: EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 240,
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: TextField(
                          focusNode: focusNode,
                          controller: TextEditingController.fromValue(
                              TextEditingValue(
                                  text: inputText1,
                                  selection: TextSelection.fromPosition(
                                      TextPosition(
                                          affinity: TextAffinity.downstream,
                                          offset: inputText1.length)))),
                          onChanged: (val) {
                            setState(() {
                              inputText1 = val;
                            });
                          },
                          maxLines: 1,
                          maxLength: 10,
                          //限制汉字
                          inputFormatters: [
                            WhitelistingTextInputFormatter(
                                RegExp("[\u4e00-\u9fa5]"))
                          ],
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 6,right: 6,bottom: 8,),
                              counterText: '',
                              // counterStyle:
                              //     TextStyle(fontSize: 10, color: Color(0xFF697373)),
                              border: InputBorder.none),
                          style: TextStyle(fontSize: 18, height: 24 / 16),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Image.asset('assets/images/position.png'),
                  iconSize: 40,
                  onPressed: () {
                    Pickers.showAddressPicker(context,
                        initProvince: '四川省',
                        initCity: '成都市',
                        initTown: '双流区', onConfirm: (p, c, m) {
                      setState(() {
                        province = p;
                        city = c;
                        area = m;
                        inputText1 = p + c + m;
                      });
                    });
                  },
                ),
              )
            ],
          ),

          // GestureDetector(
          //   onTap: (){
          //     Pickers.showAddressPicker(
          //       context,
          //       initProvince: '四川省',
          //       initCity: '成都市',
          //       initTown: '双流区',
          //       onConfirm: (p,c,m){
          //         setState(() {
          //           province = p;
          //           city = c;
          //           area = m;
          //         });
          //       }
          //     );
          //   },
          //   child: Container(
          //     padding: EdgeInsets.only(right: 20,left: 40,top: 10,bottom: 10),
          //     child: Row(
          //       children: [
          //         Expanded(
          //           child: Text('省：$province',style: TextStyle(fontSize: 18,color: Colors.black),),
          //           flex: 1,
          //         ),
          //         Expanded(
          //           child: Text('市:$city',style: TextStyle(fontSize: 18,color: Colors.black),),
          //           flex: 1,
          //         ),
          //         Expanded(
          //           child: Text('区：$area',style: TextStyle(fontSize: 18,color: Colors.black),),
          //           flex: 1,
          //         )
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget whatsName() {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '给您的产品起个名字吧',
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
          SizedBox(
            height: 12,
            width: MediaQuery.of(context).size.width,
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  // padding: EdgeInsets.only(left: 4),
                  height: 40,
                  width: 240,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: TextField(
                    focusNode: _focusNode,
                    controller: TextEditingController.fromValue(
                        TextEditingValue(
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
                    style: TextStyle(fontSize: 18, height: 24 / 16),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Image.asset('assets/images/intro.png'),
                  iconSize: 40,
                  onPressed: () async {
                    setState(() {
                      inputText = '长顺绿壳鸡蛋';
                    });
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
