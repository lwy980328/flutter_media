
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_media/util/utils.dart';




/// 加载本地资源图片
Widget loadAssetImage(String name, {double width, double height, BoxFit fit,Color color}){
  return Image.asset(
    Utils.getImgPath(name),
    height: height,
    width: width,
    fit: fit,
    color: color,
  );
}
//
///// 加载网络图片
//Widget loadNetworkImage(String imageUrl, {String placeholder : "none", double width, double height, BoxFit fit: BoxFit.cover}){
//  print(imageUrl);
//  return CachedNetworkImage(
//    imageUrl: imageUrl == null ? "" : imageUrl,
//    placeholder: (context, url) => loadAssetImage(placeholder, height: height, width: width, fit: fit),
//    errorWidget: (context, url, error) => loadAssetImage(placeholder, height: height, width: width, fit: fit),
//    width: width,
//    height: height,
//    fit: fit,
//  );
//}