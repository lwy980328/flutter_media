

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media/util/image_utils.dart';

class PaperPage extends StatefulWidget {
  @override
  _PaperPageState createState() => _PaperPageState();
}

class _PaperPageState extends State<PaperPage> with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var tabText = ['全部','草稿','待审核','需修改','已发布'];

  TabController _tabController;
  List<Widget> tabs = [];

  @override
  void initState() {
    _tabController = TabController(length: tabText.length, vsync: this);
    tabText.forEach((value) {
      tabs.add(Text(
        value,
        style: TextStyle(fontSize: 16),
      ));
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFF6F7F8),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: Container(
        margin: EdgeInsets.only(left: 16),
        child:IconButton(
          icon: loadAssetImage('wenzhang.png',height: 24,fit: BoxFit.fitHeight),
        )),
        actions: [
          GestureDetector(
            child: loadAssetImage('suosou.png', width: 24.0,
                height: 24.0,
                fit: BoxFit.contain),
          ),
          SizedBox(width: 16,)
        ],
        title: Text("内容"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          TabBar(
              isScrollable: true,
              controller: _tabController,
              labelPadding: EdgeInsets.only(
                  left: 16, right: 16, bottom: 10, top: 10),
              indicatorColor: Colors.blue,
              indicatorWeight: 3,
              labelColor: Color(0xff2d3434),
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: Color(0xff8b9696),
              unselectedLabelStyle: TextStyle(fontSize: 16),
              labelStyle: TextStyle(fontSize: 16.0),
              tabs: tabs),
          SizedBox(height: 10,),
          Expanded(
              child: TabBarView(
                  controller: _tabController,
                  children: tabText.map((value) {
                    return _buildListView();
                  }).toList())),
        ],
      ),
    );
  }

  Widget _buildListView(){
    return Container(
        color: Colors.white,
        //padding: EdgeInsets.only(left: 16, right: 16),
        //margin: EdgeInsets.only(bottom: 16),
        child: ListView.separated(
          padding: EdgeInsets.only(left: 15, right: 15),
          physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 6,
          itemBuilder: (context, index) => _buildItem(index),
          separatorBuilder: (BuildContext context, int index) {
            return Container(
              color: Colors.white,
              child: Container(
                color: Color(0xfff3f2f2),
                height: 1,
              ),
            );
          },
        ));
  }
  _buildItem(int index) {
    return GestureDetector(
      onTap: (){
        // NavigatorUtil.pushPage(context, CourseIntroductionPage(courseList[index].id));
      },
      child: Container(
        // color: Colors.white,
        margin: EdgeInsets.only(bottom: 15,top: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 95,
              width: 134,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Center(
                child: loadAssetImage('bofang.png',width: 45,fit: BoxFit.fitWidth),
              )
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Container(
                height: 95,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '这里产的鸡蛋"不一般',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: 16),
                    ),
                    Container(
                      // margin: EdgeInsets.only(top: 8),
                      child: Text(
                        '日销100份，一上架就备受好评的长顺旅客鸡蛋，本周特价优惠啦！美食之旅常有意外金币',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 14,color: Color(0xFF697373),),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '2017.04.15',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14,color:Color(0xFFBEC2C2),),
                        ),
                        Text(
                          '待审核',
                          style: TextStyle(fontSize: 14,color: Colors.greenAccent),
                        ),
//                        courseList[index].viewCount==null?
//                        Text('0人正在学'):Text(courseList[index].viewCount.toString()+'人正在学')
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}