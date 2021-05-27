import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media/bean/content_bean.dart';
import 'package:flutter_media/net/dio_utils.dart';
import 'package:flutter_media/net/api.dart';
import 'package:flutter_media/util/common.dart';
import 'package:flutter_media/util/image_utils.dart';
import 'package:flutter_media/util/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'loading_widget.dart';
import 'no_data.dart';

class ContentTabView extends StatefulWidget {
  final int conditionId;//年级
  final int menuId;
  ContentTabView({Key key, this.conditionId, this.menuId})
      : super(key: key);
  @override
  _ContentTabViewState createState() => _ContentTabViewState();
}

class _ContentTabViewState extends State<ContentTabView> {
  List<ContentBean> bookList = List();
  int pageNum = 1;
  Widget loading = LoadingWidget.childWidget();

  @override
  void initState() {
    super.initState();
    _requestData();
  }

  @override
  void didUpdateWidget(ContentTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.conditionId != oldWidget.conditionId) {
      pageNum = 1;
      bookList.clear();
      _requestData();
    }
  }


  _requestData() {
    DioUtils.instance.requestNetwork<ContentBean>(Method.get, Api.GET_BY_TAB,
        queryParameters: {
          'conditionId': widget.conditionId,
          'currentPageNum': pageNum,
          'pageSize': 10,
          'menuId': widget.menuId,
          'roleId': Utils.sharedPreferences.getString(Constant.role_Id),
          'userId': Utils.sharedPreferences.getString(Constant.user_Id),
        },
        isList: true, onSuccessList: (data) {
          if (data == null || data.length == 0) {
            if(mounted){
              setState(() {
                loading = NoData();
              });
            }
            _refreshController.loadNoData();
          } else {
            pageNum++;
            _refreshController.loadComplete();
          }
          if(mounted){
            setState(() {
              bookList.addAll(data);
              _refreshController.refreshCompleted();
              print("获取列表成功");
            });
          }
        }, onError: (code, msg) {
          _refreshController.refreshFailed();
          _refreshController.loadFailed();
          if(mounted){
            setState(() {
              loading = NoData();
            });
          }
          print("获取列表失败");
        });
  }

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async {
//    Toast.show('这是下拉刷新操作');
    if (bookList == null || bookList.length == 0) {
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
  Widget build(BuildContext context) {
    return bookList.isEmpty
        ? loading
        : Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15),
        //margin: EdgeInsets.only(bottom: 16),
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropHeader(
            complete: Text(
              "刷新成功！",
              style: TextStyle(fontSize: 14, color: Color(0xFFA7B1B1)),
            ),
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
            itemCount: bookList.length,
            itemBuilder: (context, index) => _buildItem(bookList[index]),
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                color: Color(0xfff3f2f2),
                height: 1,
              );
            },
          ),
        ));
  }

  _buildItem(ContentBean bean) {
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
                    image: NetworkImage(bean.image),
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
                      '${bean.scriptMainTitle}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: 16),
                    ),
                    Container(
                      // margin: EdgeInsets.only(top: 8),
                      child: Text(
                        bean.abstractContent==null?'':'${bean.abstractContent}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 14,color: Color(0xFF697373),),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${Utils.dateAndTimeToString(bean.time,formart: {"y-m":".","m-d":"."})}'??'',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14,color:Color(0xFFBEC2C2),),
                        ),
                        Text(
                          '${bean.scriptStatusName}',
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