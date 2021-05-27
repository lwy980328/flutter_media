import 'package:flutter/material.dart';
import 'package:flutter_media/util/image_utils.dart';
class NoData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(child:
      Text('暂无数据',style: TextStyle(color: Color(0xFF3B3E3E),fontSize: 18),),)
      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: <Widget>[
      //     loadAssetImage('empty.png'),
      //     SizedBox(height: 15,),
      //     Text('暂无数据',style: TextStyle(color: Color(0xFF3B3E3E),fontSize: 18),)
      //   ],
      // ),
    );
  }
}
