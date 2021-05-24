

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media/util/image_utils.dart';

class ManagePage extends StatefulWidget {
  @override
  _ManagePageState createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var tabText = ['整体数据','渠道概要','内容分发数据'];
  var value;
  List<DropdownMenuItem<String>> sortItems = List();

  TabController _tabController;
  List<Widget> tabs = [];
  List<Widget> tabViews = [];

  @override
  void initState() {
    _tabController = TabController(length: tabText.length, vsync: this);
    tabText.forEach((value) {
      tabs.add(Text(
        value,
        style: TextStyle(fontSize: 18),
      ));
    });
    super.initState();
    tabViews.add(_buildGridView());
    tabViews.add(_buildListView());
    tabViews.add(_buildGridView());
    sortItems.add(DropdownMenuItem(
        value: '本周',
        child: Center(child: Text(
            '本周',style: TextStyle(fontSize: 18)
        ),)));
    sortItems.add(DropdownMenuItem(
        value: '上周',
        child: Center(child: Text(
            '上周',style: TextStyle(fontSize: 18)
        ),)));
    sortItems.add(DropdownMenuItem(
        value: '两周前',
        child: Center(child: Text(
            '两周前',style: TextStyle(fontSize: 18)
        ),)));
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
        title: Text("营销"),
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
              unselectedLabelStyle: TextStyle(fontSize: 18),
              labelStyle: TextStyle(fontSize: 18.0),
              tabs: tabs),
          Container(
            color: Color(0xfff3f2f2),
            // margin: EdgeInsets.only(left: 16, right: 16),
            // width: MediaQuery.of(context).size.width-32,
            height: 1,
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: DropdownButton(
              isExpanded: true,
              hint: Center(
                child: Text(
                  '请选择时间',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
              value: value,
              items: sortItems,
              onChanged: (selectValue) {
                //选中后的回调
                setState(() {
                  value = selectValue;
                });
              },
              style: new TextStyle(
                //设置文本框里面文字的样式
                  color: Colors.black,
                  fontSize: 12),
              underline: Container(),
            ),
          ),
          Container(
            color: Color(0xfff3f2f2),
            height: 1,
          ),
          SizedBox(height: 10,),
          Expanded(
              child: TabBarView(
                  controller: _tabController,
                  children: tabViews)),
        ],
      ),
    );
  }

  Widget _buildListView(){
    return Container(
      //height: 104,
      padding: EdgeInsets.only(left: 16, right: 16, top: 0),
      margin: EdgeInsets.only(bottom: 16),
      child: ListView.separated(
        physics: AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (context, index) => _buildListItem(),
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            color: Color(0xfff3f2f2),
            height: 1,
          );
        },
      ),
    );
  }

  _buildListItem(){
    return GestureDetector(
      onTap: () {

        // NavigatorUtil.pushPage(context, BookDetailPage(bookBean.id, widget.type));
      },
      child: Container(
        margin: EdgeInsets.only(top: 15, bottom: 15),
        //height:  MediaQuery.of(context).size.width*0.48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              // height: 126,
              // width: 96,
              child: loadAssetImage("huiyi.png",
                  width: 96,
                  height: 96,
                  fit: BoxFit.fill
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Container(
                height: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '欢科溶酶体',
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xFF697373)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                Text(
                                  '新增粉丝：18',
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xFF697373)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '周发布稿件：0',
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xFF697373)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                Text(
                                  '总发布稿件：35',
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xFF697373)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Spacer(),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        loadAssetImage('view_num.png',height: 18,fit: BoxFit.fitHeight),
                          SizedBox(width: 5,),
                          Text('0',
                              style: TextStyle(
                              fontSize: 16, color: Color(0xFF697373)),
                           ),
                          Spacer(),
                          loadAssetImage('praise_num.png',height: 18,fit: BoxFit.fitHeight),
                          SizedBox(width: 5,),
                          Text('0',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFF697373)),
                          ),
                          Spacer(),
                          loadAssetImage('forward_num.png',height: 18,fit: BoxFit.fitHeight),
                          SizedBox(width: 5,),
                          Text('0',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFF697373)),
                          ),
                          Spacer(),
                        ],
                      ),
                      // Spacer(),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          loadAssetImage('recommend_num.png',height: 18,fit: BoxFit.fitHeight),
                          SizedBox(width: 5,),
                          Text('0',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFF697373)),
                          ),
                          Spacer(),
                          loadAssetImage('collect_num.png',height: 18,fit: BoxFit.fitHeight),
                          SizedBox(width: 5,),
                          Text('0',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFF697373)),
                          ),
                          Spacer(),
                          loadAssetImage('comment_num.png',height: 18,fit: BoxFit.fitHeight),
                          SizedBox(width: 5,),
                          Text('0',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFF697373)),
                          ),
                          Spacer(),
                        ],
                      )

                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(){
    return Container(
      //height: 104,
      padding: EdgeInsets.only(left: 16, right: 16, top: 0),
      margin: EdgeInsets.only(bottom: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: 8,
        //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //横轴元素个数
            crossAxisCount: 2,
            //纵轴间距
            mainAxisSpacing: 16.0,
            //横轴间距
            crossAxisSpacing: 16.0,
            //子组件宽高长度比例
            childAspectRatio: 478/323),
        itemBuilder: (context, index) => _buildItem(index),
      ),
    );
  }

  _buildItem(int index) {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        padding: EdgeInsets.all(15),

        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: Color(0xFF697373),
                width: 0.5),
            ),
        child: Row(

                 children: [
                   loadAssetImage('course.png',width: 60,fit: BoxFit.fitWidth),
                   SizedBox(width: 15,),
                   Container(

                     child: Center(
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                           Text(
                             '66',
                             style: TextStyle(fontSize: 16, color: Color(0xff6c5b42)),
                           ),
                           SizedBox(height: 8,),
                           Container(
                             // width: MediaQuery.of(context).size.width,
                             child: Container(
                               // height: 35,
                               child: Text(
                                 '文章数',
                                 style: TextStyle(fontSize: 16, color: Color(0xff6c5b42)),
                                 maxLines: 2,),
                             ),)
                         ],
                       ),
                     ),
                   )


                 ],
             ),
      ),
    );
  }
}