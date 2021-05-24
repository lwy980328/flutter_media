import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_media/pages/adds/add_page.dart';
import 'package:flutter_media/pages/adds/start_product.dart';
import 'package:flutter_media/pages/first_page.dart';
import 'package:flutter_media/pages/sale_page.dart';
import 'package:flutter_media/pages/mine_page.dart';
import 'package:flutter_media/pages/paper_page.dart';
import 'package:flutter_media/util/image_utils.dart';
import 'package:flutter_media/util/toast.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectIndex = 0;
  List<BottomNavigationBarItem> itemList;
  List<Widget> pages;
  final defaultItemColor = Color(0xffbec2c2);
  DateTime lastPopTime;

  final itemNames = [
    _Item('首页', 'shouye_on.png', 'shouye_off.png'),
    _Item('内容', 'gaojian_on.png', 'gaojian_off.png'),
    _Item('', 'ic_post_on.png', 'ic_post_off.png'),
    _Item('营销', 'tongji_on.png', 'tongji_off.png'),
    _Item('我的', 'wode_on.png', 'wode_off.png')
  ];

//回调进首页
  void onPressFirstBtn() {
    setState(() {
      _selectIndex = 0;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (pages == null) {
      pages = [FirstPage(), PaperPage(), AddPage(), ManagePage(), MinePage()];
    }
    if (itemList == null) {
      itemList = itemNames
          .map((item) => item.name == ''
              ? BottomNavigationBarItem(
                  icon: Center(
                    child: loadAssetImage(item.normalIcon,
                        height: 33.0, fit: BoxFit.fitHeight),
                  ),
                  title: Container(
                    height: 0,
                    width: 0,
                  ),
                  activeIcon: Center(
                    child: loadAssetImage(item.activeIcon,
                        height: 33.0, fit: BoxFit.fitHeight),
                  ))
              : BottomNavigationBarItem(
                  icon: loadAssetImage(
                    item.normalIcon,
                    width: 22.0,
                    height: 22.0,
                  ),
                  title: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 11.0,
                    ),
                  ),
                  activeIcon: loadAssetImage(item.activeIcon,
                      width: 22.0, height: 22.0)))
          .toList();
    }
  }

  Widget _getPagesWidget(int index) {
    return Offstage(
      offstage: _selectIndex != index,
      child: TickerMode(
        enabled: _selectIndex == index,
        child: pages[index],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    return Scaffold(
//      body: new Stack(
//        children: [
//          _getPagesWidget(0),
//          _getPagesWidget(1),
//          _getPagesWidget(2),
//          _getPagesWidget(3),
//          _getPagesWidget(4),
//        ],
//      ),
//      backgroundColor: Colors.white,
//      bottomNavigationBar: BottomNavigationBar(
//        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//        unselectedItemColor: Theme.of(context).textTheme.body2.color,
//        elevation: 0,
//        items: itemList,
//        onTap: (int index) {
//          ///这里根据点击的index来显示，非index的page均隐藏
//          setState(() {
//            _selectIndex = index;
//            //这个是用来控制比较特别的shopPage中WebView不能动态隐藏的问题
//          });
//        },
//        //图标大小
//        iconSize: 24,
//        //当前选中的索引
//        currentIndex: _selectIndex,
//        //unselectedLabelStyle: Theme.of(context).textTheme.body1,
//        //选中后，底部BottomNavigationBar内容的颜色(选中时，默认为主题色)（仅当type: BottomNavigationBarType.fixed,时生效）
//        fixedColor: Color(0xff3aa4a5),
//        type: BottomNavigationBarType.fixed,

    return WillPopScope(
        child: Scaffold(
          body: new Stack(
            children: [
              _getPagesWidget(0),
              _getPagesWidget(1),
              _getPagesWidget(2),
              _getPagesWidget(3),
              _getPagesWidget(4),
            ],
          ),
          backgroundColor: Colors.white,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            unselectedItemColor: Color(0xffc3c3c6),
            elevation: 0,
            items: itemList,
            onTap: (int index) {
              ///这里根据点击的index来显示，非index的page均隐藏
              if(index == 2){
                Navigator.push(
                    context,
                    new CupertinoPageRoute<void>(
                        builder: (ctx) => StartProductPage()));
              }else{
                setState(() {
                  _selectIndex = index;
                  //这个是用来控制比较特别的shopPage中WebView不能动态隐藏的问题
                });
              }

            },
            //图标大小
            iconSize: 24,
            //当前选中的索引
            currentIndex: _selectIndex,
            //选中后，底部BottomNavigationBar内容的颜色(选中时，默认为主题色)（仅当type: BottomNavigationBarType.fixed,时生效）
            fixedColor: Color(0xff3aa4a5),
            type: BottomNavigationBarType.fixed,
          ),
        ),
        onWillPop: () async {
          // 点击返回键的操作
          if (lastPopTime == null ||
              DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
            lastPopTime = DateTime.now();
            Toast.show('再按一次退出');
            return;
          } else {
            lastPopTime = DateTime.now();
            // 退出app
            await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return;
          }
        });
  }
}

class _Item {
  String name, activeIcon, normalIcon;

  _Item(this.name, this.activeIcon, this.normalIcon);
}
