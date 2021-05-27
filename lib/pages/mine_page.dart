

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media/bean/infoList_bean.dart';
import 'package:flutter_media/bean/user_bean.dart';
import 'package:flutter_media/net/api.dart';
import 'package:flutter_media/net/dio_utils.dart';
import 'package:flutter_media/util/common.dart';
import 'package:flutter_media/util/image_utils.dart';
import 'package:flutter_media/util/utils.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
    List subjects = ['我的收藏','我的课程','我的业绩','意见反馈','更多设置'];
    List images = ['collect.png','course.png','down.png','feedback.png','setting.png'];
    UserBean userInfo = new UserBean();
  @override
  void initState() {
    super.initState();
    _requestData();
  }

    _requestData() {
      DioUtils.instance.requestNetwork<UserBean>(
          Method.get, Api.USER_INFO, queryParameters: {

        'userId': Utils.sharedPreferences.getString(Constant.user_Id),
      },
          onSuccess: (data) {
            setState(() {
              userInfo = data;
              print("获取成功");
            });
          }, onError: (code, msg) {
        print("获取失败");
      });
    }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFF6F7F8),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),

        children: [
          Container(
            height: MediaQuery.of(context).size.width*650/1075,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/banner.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                 child: ClipOval(
                   child: loadNetworkImage(userInfo.photo,fit: BoxFit.fill,width: 90,height: 90,placeholder: 'logo_login.png')
                 ),
                ),
                Text('${userInfo.userName}',
                    style: TextStyle(fontSize: 18, color: Colors.white)
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   loadAssetImage('icon_head.png',fit: BoxFit.fill,width: 16,height: 16),
                   SizedBox(width: 12,),
                   Text('${userInfo.userPosition}',
                       style: TextStyle(fontSize: 15, color: Colors.white)
                   ),
                 ],
                )
              ],
            ),
          ),
          ListView.separated(
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index) => _buildItem(index),
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                color: Color(0xfff3f2f2),
                margin: EdgeInsets.only(left: 16, right: 16),
                height: 1,
              );
            },
          ),
          Container(
            color: Color(0xFFF6F7F8),
            margin: EdgeInsets.only(left: 16, right: 16),
            height: 20,
          ),
          ListView.separated(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 2,
              itemBuilder: (context, index) => _buildItem(index+3),
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  color: Color(0xFFE1E8EE),
                  margin: EdgeInsets.only(left: 16, right: 16),
                  height: 1,
                );
              }),
        ],
      ),
    );
  }
    _buildItem(int index) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (index == 0) {
            // NavigatorUtil.pushPage(context, StudyPlanPage('学习计划', 1));
          } else if (index == 1) {
            // NavigatorUtil.pushPage(context, MemberService());
          } else if (index == 2) {
            // NavigatorUtil.pushPage(context, GrowTrackPage());
          } else if (index == 3) {
            // NavigatorUtil.pushPage(context, CoinMedalPage());
          }  else if (index == 4) {
            // NavigatorUtil.pushPage(context, SuggestionPage());
          }
          },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(16),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 20,
                width: 20,
                child: loadAssetImage(images[index], fit: BoxFit.contain),
                // loadAssetImage('mine${index + 1}.png', fit: BoxFit.contain),
                //Image.network(widget.list[index].iconUrl,fit: BoxFit.fill,),
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                subjects[index],
                style: TextStyle(fontSize: 16, color: Color(0xFF2D3434)),
              ),
              Expanded(child: Container()),
              loadAssetImage('more.png', height: 14, width: 14),
            ],
          ),
        ),
      );

      }
}