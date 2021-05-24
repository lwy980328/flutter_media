import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
class VideoPage extends StatelessWidget {
  final String filePath;
  VideoPage({@required this.filePath});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: VideoMain(filePath: this.filePath,),
    );
  }
}

class VideoMain extends StatefulWidget {
  final String filePath;
  VideoMain({Key key,@required this.filePath}) : super(key: key);
  @override
  _VideoMainState createState() => _VideoMainState();
}

class _VideoMainState extends State<VideoMain> {

  VideoPlayerController _videoController;


  @override
  void initState() {
    // TODO: implement initState
    print('文件路径是${widget.filePath}');
    _videoController = VideoPlayerController.file(File(widget.filePath),videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),);
    _videoController.addListener(() {
      setState(() {});
    });
    _videoController.setLooping(true);
    _videoController.initialize().then((_) => setState(() {}));
    _videoController.play();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Stack(
      children: [
        // Container(
        //   child: Transform.scale(
        //     scale: _videoController.value.aspectRatio/deviceRatio,
        //     child: Center(
        //       child: AspectRatio(
        //         aspectRatio: _videoController.value.aspectRatio,
        //         child: VideoPlayer(_videoController),
        //       ),
        //     ),
        //   ),
        // ),
        Container(
          child: Center(
            child: AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: VideoPlayer(_videoController),
            ),
          ),
        ),

        Positioned(
          //顶部关闭按钮
          top: 50,
          left: 20,
          child: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
              size: 32,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),

      ],
    );
  }
}
