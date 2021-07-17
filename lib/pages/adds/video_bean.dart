import 'package:flutter/cupertino.dart';

class videoBean{
  int position;
  int id;
  int templateVideoId;
  String boardUrl;
  String tips;
  String words;
  String audio;


  videoBean(this.id,this.position,this.templateVideoId,this.boardUrl,this.tips,this.words,{this.audio}):super();
}