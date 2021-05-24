

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media/MyHomePage.dart';
import 'package:flutter_media/util/navigator_util.dart';
import 'package:flutter_media/util/image_utils.dart';
import 'package:flutter_media/widget/text_field.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String inputName = '';
  String inputPassword = '';
  TextEditingController _nameController;
  TextEditingController _passwordController;
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();

  @override
  void initState() {
    _nameController = TextEditingController.fromValue(TextEditingValue(
      // 设置内容
        text: inputName,
        // 保持光标在最后
        selection: TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream, offset: inputName.length))));
    _passwordController = TextEditingController.fromValue(TextEditingValue(
      // 设置内容
        text: inputPassword,
        // 保持光标在最后
        selection: TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream, offset: inputPassword.length))));
  }

  @override
  Widget build(BuildContext context) {

   return Scaffold(
     backgroundColor: Colors.white,
     body: SingleChildScrollView(
       child: Container(
         padding: EdgeInsets.only(left: 25,right: 25),
         height: MediaQuery.of(context).size.height,
         // decoration: BoxDecoration(
         //   color: Color(0xFF52B4B5),
         //   image: DecorationImage(
         //       image: AssetImage('assets/images/login/login_bg.png'),
         //       fit: BoxFit.fitWidth,
         //       alignment: Alignment.bottomCenter),
         // ),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           children: <Widget>[
             SizedBox(
               height: 50,
             ),
             Center(
               child: loadAssetImage('huanke.png',
                   height: 68, width: 68, fit: BoxFit.fill),
             ),
             SizedBox(
               height: 40,
             ),

             MyTextField(
               focusNode: _nodeText1,
               prefixIcon: 'login_head.png',
               controller: _nameController,
               maxLength: 18,
               hintText: "用户名称",
             ),
             SizedBox(
               height: 30,
             ),
             MyTextField(
               focusNode: _nodeText2,

               prefixIcon: 'password.png',
               isInputPwd: true,
               controller: _passwordController,
               maxLength: 16,
               hintText: "用户密码",
             ),
             SizedBox(
               height: 30,
             ),

             GestureDetector(
               onTap: () {
                 NavigatorUtil.pushReplacementNamed(context, MyHomePage());
               },
               child: Container(
                 width: MediaQuery.of(context).size.width,
                 height: 48,
                 margin:
                 EdgeInsets.only(top: 20, bottom: 20,),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(1520.0),
                   color: Colors.blue,
                 ),
                 child: Center(
                     child: Text('登 录', style: TextStyle(fontSize: 20,color: Colors.white))),
               ),
             ),
             SizedBox(
               height: 30,
             ),

             GestureDetector(
                 behavior: HitTestBehavior.opaque,
                 onTap: () {
                   // NavigatorUtil.pushPage(context, ForgetPwdPage());
                 },
                 child: Text(
                   '忘记密码 ？',
                   style: TextStyle(color: Color(0xfff87484)),
                 ),  ),
             Spacer(),
           ],
         ),
       ),
     ),

     resizeToAvoidBottomInset: false,
   );
  }

}