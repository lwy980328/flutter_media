
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_media/util/image_utils.dart';

import 'package:rxdart/rxdart.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class MyTextField extends StatefulWidget {

  const MyTextField({
    Key key,
    @required this.controller,
    this.maxLength: 16,
    this.autoFocus: false,
    this.keyboardType: TextInputType.text,
    this.hintText: "",
    this.prefixIcon,
    this.isChange:false,
    this.focusNode,
    this.isInputPwd: false,
    this.getVCode,
    this.config,
    this.enable:true,
  }): super(key: key);

  final TextEditingController controller;
  final int maxLength;
  final bool autoFocus;
  final String prefixIcon;
  final bool isChange;
  final TextInputType keyboardType;
  final String hintText;
  final FocusNode focusNode;
  final bool isInputPwd;
  final Function getVCode;
  final KeyboardActionsConfig config;
  final bool enable;
  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _isShowPwd = false;
  bool _isShowDelete = true;
  bool _isClick = true;

  @override
  void initState() {
    super.initState();
    //监听输入改变
    widget.controller.addListener((){
      setState(() {
        _isShowDelete = widget.controller.text.isEmpty;
      });
    });
    if (widget.config != null && defaultTargetPlatform == TargetPlatform.iOS){
      // 因Android平台输入法兼容问题，所以只配置IOS平台
    }
  }

  @override
  void dispose() {

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: widget.prefixIcon == null?20:10,right: 15),

      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  color: Color(0xffc3c3c6),
                  width: 1.0,
                  style: BorderStyle.solid
              )
          ),  //Border.all(color: widget.enable?Colors.black12:Colors.white, width: 1),
          ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          TextField(
            enableInteractiveSelection: false,
            enabled: widget.enable??true,
            focusNode: widget.focusNode,
            maxLength: widget.maxLength,
            obscureText: widget.isInputPwd ? !_isShowPwd : false,
            autofocus: widget.autoFocus,
            controller: widget.controller,
            cursorColor: Colors.green,
            textInputAction: TextInputAction.done,
            keyboardType: widget.keyboardType,
            // 数字、手机号限制格式为0到9(白名单)， 密码限制不包含汉字（黑名单）
            inputFormatters: (widget.keyboardType == TextInputType.number || widget.keyboardType == TextInputType.phone) ?
            [WhitelistingTextInputFormatter(RegExp("[0-9]"))] : [BlacklistingTextInputFormatter(RegExp("[\u4e00-\u9fa5]"))],
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Color(0xffc3c3c6)),
              prefixIcon: widget.prefixIcon == null?null:Container(
                padding: EdgeInsets.all(12),
                child: loadAssetImage(widget.prefixIcon,
                    width: 5,
                    height:5,
                    fit: BoxFit.fitHeight
                ),
              ),
              counterText: "",
              border: InputBorder.none,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Offstage(
                offstage: _isShowDelete,
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: loadAssetImage("x.png",
                    width: 18.0,
                    height: 18.0,
                  ),
                  onTap: (){
                    setState(() {
                      widget.controller.text = "";
                    });
                  },
                ),
              ),
              Offstage(
                offstage: !widget.isInputPwd,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: loadAssetImage(
                      _isShowPwd ? "qyg_shop_icon_display.png" : "qyg_shop_icon_hide.png",
                      width: 18.0,
                      height: 18.0,
                    ),
                    onTap: (){
                      setState(() {
                        _isShowPwd = !_isShowPwd;
                      });
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      ),

    );
  }
}
