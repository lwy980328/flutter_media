import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_media/pages/adds/html_bean.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'htmlMarketContro.dart';

class HtmlMarket extends StatefulWidget {
  // htmlbean data;
  htmlMarketController data;


  HtmlMarket(this.data);
  @override
  _HtmlMarketState createState() => _HtmlMarketState();
}

class _HtmlMarketState extends State<HtmlMarket> with AutomaticKeepAliveClientMixin{
  String htmldata = '';


   getData() async {
    var i = {
      '名称': '海淀鸡蛋',
      '产地': '北京市海淀区',
      '特色': '好吃',
      '关键词': '鸡蛋',
      '联系方式': '小明',
    };
    var k = {
      '名称': widget.data.htmb.name,
      '产地': widget.data.htmb.productplace,
      '特色': widget.data.htmb.character.toString(),
      '关键词': widget.data.htmb.keyword==''?"鸡蛋":widget.data.htmb.keyword,
      '联系方式': '小明',
    };

    var j = convert.jsonEncode(k);

    var url = Uri.parse(
        'http://39.105.219.200:18080/temController/articleComposition');
    var response = await http.post(url, body: j);
    print(response.request);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      setState(() {
        htmldata = convert.jsonDecode(response.body)['data'];
      });
    } else if (response.statusCode == 500) {
      getData();
    }
  }

  // readHtml() async {
  //   htmldata = await rootBundle.loadString('assets/html/demo.html');
  //   print(htmldata);
  // }


  @override
  void didUpdateWidget(covariant HtmlMarket oldWidget) {
    // TODO: implement didUpdateWidget
    // getData();
    if(oldWidget.data !=widget.data){
      getData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
