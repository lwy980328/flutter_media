
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_media/bean/infoList_bean.dart';
import 'package:flutter_media/net/api.dart';
import 'package:flutter_media/net/dio_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media/bean/overview_bean.dart';
import 'package:flutter_media/util/common.dart';
import 'package:flutter_media/util/image_utils.dart';
import 'package:flutter_media/util/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  OverviewBean scriptData = OverviewBean();
  List<InfoListBean> infoList = List();
  int pageNum = 1;


  _getScript(){
    DioUtils.instance.requestNetwork<OverviewBean>(
        Method.get, Api.GET_SCRIPT, queryParameters: {
          'roleId': Utils.sharedPreferences.getString(Constant.role_Id),
          'userId': Utils.sharedPreferences.getString(Constant.user_Id),
    },
        onSuccess: (data) {
      setState(() {
        scriptData = data;
        print("获取个人概况成功:${scriptData.toString()}");
      });
    }, onError: (code, msg) {
      print("获取个人概况失败");
    });
  }
  _requestData() {
    DioUtils.instance.requestNetwork<InfoListBean>(
        Method.get, Api.GET_BOARD_INFO, isList: true, queryParameters: {
      'currentPageNum': pageNum,
      'pageSize': 10,
      'type': 0,
      'userId': Utils.sharedPreferences.getString(Constant.user_Id),
    },
        onSuccessList: (data) {
          setState(() {
            infoList = data;
            print("获取布告栏成功:${infoList.toString()}");
          });
        }, onError: (code, msg) {
      print("获取布告栏失败");
    });
  }

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async {
//    Toast.show('这是下拉刷新操作');
    if (infoList == null || infoList.length == 0) {
      _requestData();
    } else {
      _refreshController.refreshCompleted();
    }
  }
  void _onLoading() async {
    _refreshController.requestLoading();
    _requestData();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getScript();
    _requestData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFF6F7F8),
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text("首页"),
          backgroundColor: Colors.blue,
        ),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, num index) {
                    return Container(
                         width: MediaQuery.of(context).size.width-30,
                         height: (MediaQuery.of(context).size.width-30)*0.648,
                         padding: EdgeInsets.only(top: ((MediaQuery.of(context).size.width-30)*0.648-116)/4,bottom: ((MediaQuery.of(context).size.width-30)*0.648-116)/4),
                         margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Color(0xFFF6F7F8),
                          image: DecorationImage(
                            image: AssetImage('assets/images/t.png'),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    flex:1,
                                    child: Column(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text("${scriptData.unReadMessageNum}",
                                              style: TextStyle(
                                                  fontSize: 30,color: Colors.white
                                              ),),
                                            SizedBox(width: 5,),
                                            Text("条",
                                              style: TextStyle(
                                                  fontSize: 16,color: Colors.white
                                              ),),
                                          ],
                                        ),

                                        SizedBox(height: 5,),
                                        Text("未读消息",
                                          style: TextStyle(
                                              fontSize: 16,color: Colors.white
                                          ),),
                                      ],
                                    ),

                                    Spacer(),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text("${scriptData.waitCheckNum}",
                                              style: TextStyle(
                                                  fontSize: 30,color: Colors.white
                                              ),),
                                            SizedBox(width: 5,),
                                            Text("个",
                                              style: TextStyle(
                                                  fontSize: 16,color: Colors.white
                                              ),),
                                          ],
                                        ),

                                        SizedBox(height: 5,),
                                        Text("爆款内容",
                                          style: TextStyle(
                                              fontSize: 16,color: Colors.white
                                          ),),
                                      ],
                                    ),
                                  ],
                                )),
                                Expanded(
                                   flex:1,
                                    child: Column(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text("${scriptData.waitPublishNum}",
                                              style: TextStyle(
                                                  fontSize: 30,color: Colors.white
                                              ),),
                                            SizedBox(width: 5,),
                                            Text("个",
                                              style: TextStyle(
                                                  fontSize: 16,color: Colors.white
                                              ),),
                                          ],
                                        ),

                                        SizedBox(height: 5,),
                                        Text("营销内容",
                                          style: TextStyle(
                                              fontSize: 16,color: Colors.white
                                          ),),
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text("${scriptData.returnedNum}",
                                              style: TextStyle(
                                                  fontSize: 30,color: Colors.white
                                              ),),
                                            SizedBox(width: 5,),
                                            Text("个",
                                              style: TextStyle(
                                                  fontSize: 16,color: Colors.white
                                              ),),
                                          ],
                                        ),

                                        SizedBox(height: 5,),
                                        Text("营销课程",
                                          style: TextStyle(
                                              fontSize: 16,color: Colors.white
                                          ),),
                                      ],
                                    ),
                                  ],
                                ))
                              ],
                            ),
                            Center(
                              child: Column(
                                children: [
                                  loadAssetImage("tianqi.png",
                                      width: (MediaQuery.of(context).size.width)/135*14,
                                      fit: BoxFit.fitWidth),
                                  Text("32°C/25°C",
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              )
                            )
                            // loadAssetImage("t.png",
                            //     width: MediaQuery.of(context).size.width-30,
                            //     fit: BoxFit.fitWidth),
                            // Positioned(
                            //   top: (MediaQuery.of(context).size.width-30)*0.324-(MediaQuery.of(context).size.width)/135*7,
                            //   left: MediaQuery.of(context).size.width/2-(MediaQuery.of(context).size.width)/135*14,
                            //   child: loadAssetImage("tianqi.png",
                            //       width: (MediaQuery.of(context).size.width)/135*14,
                            //       fit: BoxFit.fitWidth),
                            // )

                          ],
                        )
                    );
                  }, childCount: 1)

              ),
            SliverAppBar(
              backgroundColor: Color(0xFFF6F7F8),
              leadingWidth: 0,
                  pinned: true,
                  bottom: PreferredSize(
                        child: Container(
                          height: 46,
                          // margin: EdgeInsets.only(top: 15),
                          color: Colors.white,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 40,
                                      child: loadAssetImage("gonggao.png",
                                          fit: BoxFit.fitHeight),
                                    ),
                                    SizedBox(width: 15,),
                                    Container(
                                      height: 45,
                                      child: Center(
                                        child: Text("热门营销",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),),
                                      ),
                                    ),

                                    Spacer(),
                                    GestureDetector(
                                      child: Container(
                                        height: 45,
                                        child: Center(
                                          child: Text("MORE",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.blue,
                                            ),),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                color: Color(0xfff3f2f2),
                                // margin: EdgeInsets.only(left: 16, right: 16),
                                // width: MediaQuery.of(context).size.width-32,
                                height: 1,
                              ),
                            ],
                          ),
                        ),
                        preferredSize: new Size(double.infinity, 0)
                    ),
            )
              // new SliverAppBar(
              //   backgroundColor: Color(0xFFF6F7F8),
              //   leadingWidth: 0,
              //   expandedHeight: (MediaQuery.of(context).size.width-30)*0.8+30,
              //   pinned: true,
              //   flexibleSpace: Container(
              //       color: Color(0xFFF6F7F8),
              //       // padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              //       child: Stack(
              //         children: [
              //           Container(
              //             width: MediaQuery.of(context).size.width-30,
              //             margin: EdgeInsets.all(15),
              //             decoration: BoxDecoration(
              //               image: DecorationImage(
              //                 image: AssetImage('assets/images/t.png'),
              //                 fit: BoxFit.fitWidth,
              //               ),
              //             ),
              //           ),
              //           Center(
              //             child: loadAssetImage("tianqi.png",
              //                 width: (MediaQuery.of(context).size.width)/135*14,
              //                 fit: BoxFit.fitWidth),
              //           )
              //           // loadAssetImage("t.png",
              //           //     width: MediaQuery.of(context).size.width-30,
              //           //     fit: BoxFit.fitWidth),
              //           // Positioned(
              //           //   top: (MediaQuery.of(context).size.width-30)*0.324-(MediaQuery.of(context).size.width)/135*7,
              //           //   left: MediaQuery.of(context).size.width/2-(MediaQuery.of(context).size.width)/135*14,
              //           //   child: loadAssetImage("tianqi.png",
              //           //       width: (MediaQuery.of(context).size.width)/135*14,
              //           //       fit: BoxFit.fitWidth),
              //           // )
              //
              //         ],
              //       )
              //   ),
              //   bottom: PreferredSize(
              //       child: Container(
              //         height: 46,
              //         // margin: EdgeInsets.only(top: 15),
              //
              //         color: Colors.white,
              //         child: Column(
              //           children: [
              //             Container(
              //               padding: EdgeInsets.only(left: 15, right: 15),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.start,
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Container(
              //                     height: 40,
              //                     child: loadAssetImage("gonggao.png",
              //                         fit: BoxFit.fitHeight),
              //                   ),
              //                   SizedBox(width: 15,),
              //                   Container(
              //                     height: 45,
              //                     child: Center(
              //                       child: Text("热门营销",
              //                         style: TextStyle(
              //                           fontSize: 18,
              //                         ),),
              //                     ),
              //                   ),
              //
              //                   Spacer(),
              //                   GestureDetector(
              //                     child: Container(
              //                       height: 45,
              //                       child: Center(
              //                         child: Text("MORE",
              //                           style: TextStyle(
              //                             fontSize: 18,
              //                             color: Colors.blue,
              //                           ),),
              //                       ),
              //                     ),
              //                   )
              //                 ],
              //               ),
              //             ),
              //             Container(
              //               color: Color(0xfff3f2f2),
              //               // margin: EdgeInsets.only(left: 16, right: 16),
              //               // width: MediaQuery.of(context).size.width-32,
              //               height: 1,
              //             ),
              //           ],
              //         ),
              //       ),
              //       preferredSize: new Size(double.infinity, 0)
              //   ),
              // )
            ];
          },
          body:  Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 15, right: 15),
              //margin: EdgeInsets.only(bottom: 16),
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(
                  complete: Text("刷新成功！",style: TextStyle(
                      fontSize: 14, color: Color(0xFFA7B1B1)),),
                ),
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus mode) {
                    Widget body;
                    if (mode == LoadStatus.idle) {
                      body = Text("加载完成！");
                    } else if (mode == LoadStatus.loading) {
                      body = CupertinoActivityIndicator();
                    } else if (mode == LoadStatus.failed) {
                      body = Text("加载失败，请重试");
                    } else {
                      body = Text("暂无更多");
                    }
                    return Container(
                      height: 55.0,
                      child: Center(child: body),
                    );
                  },
                ),
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: ListView.separated(
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: infoList.length,
                  itemBuilder: (context, index) =>
                      _buildItem(infoList[index]),
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      color: Color(0xfff3f2f2),
                      height: 1,
                    );
                  },
                ),
              ))
      ),

    );
  }
  _buildItem(InfoListBean bean) {
    return GestureDetector(
      onTap: () {

        // NavigatorUtil.pushPage(context, BookDetailPage(bookBean.id, widget.type));
      },
      child: Container(
        margin: EdgeInsets.only(top: 15, bottom: 15),
        //height:  MediaQuery.of(context).size.width*0.48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  // height: 126,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${bean.title}'??'',
                            style: TextStyle(
                                fontSize: 18, color: Color(0xFF2D3434)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          // Container(
                          //   child:  Html(data: '${bean.content}'??'',
                          //     shrinkToFit: true,
                          //     defaultTextStyle: TextStyle(
                          //       color: Color(0xFFBEC2C2),
                          //       fontSize: 15,
                          //       height: 17
                          //     ),
                          //   ),
                          //   height: 34,
                          // ),

                          Text(
                            '${bean.content}'??'',
                            style: TextStyle(
                              color: Color(0xFFBEC2C2),
                              fontSize: 15,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${bean.authorName}'??'',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF697373),
                                ),
                              ),
                              Row(
                                children: [
                                  loadAssetImage('time.png',
                                      width: 13,
                                      height: 13,
                                      fit: BoxFit.fill),
                                  SizedBox(width: 5,),
                                  Text('${Utils.dateAndTimeToString(bean.time,formart: {"y-m":".","m-d":"."})}'??'', style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF697373),
                                  ),)
                                ],
                              )
                            ],
                          )

                        ],
                      ),

                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

}