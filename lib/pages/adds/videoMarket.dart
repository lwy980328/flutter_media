import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media/pages/adds/video_0_bean.dart';
import 'package:flutter_media/util/navigator_util.dart';
import 'package:video_player/video_player.dart';

import '../../MyHomePage.dart';
import 'Camera.dart';
import 'CameraPage.dart';

class VideoMarket extends StatefulWidget {
  video0bean video0;
  VideoMarket(this.video0);
  @override
  _VideoMarketState createState() => _VideoMarketState();
}

class _VideoMarketState extends State<VideoMarket> with WidgetsBindingObserver,AutomaticKeepAliveClientMixin{

  VideoPlayerController _videoPlayerController;
  @override
  void initState() {

    _videoPlayerController = VideoPlayerController.network(
      widget.video0.videoUrl,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _videoPlayerController.addListener(() {
setState(() {

});
    });
    // _videoPlayerController.setLooping(true);
    _videoPlayerController.initialize().then((_) => setState(() {}));
    super.initState();
  }

  @override
  void didHaveMemoryPressure() {
    // TODO: implement didHaveMemoryPressure
    _videoPlayerController.dispose();
    _videoPlayerController = null;
    super.didHaveMemoryPressure();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   switch (state) {
  //     case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
  //       print('这个是状态11111111');
  //       break; case AppLifecycleState.resumed:// 应用程序可见，前台
  //     print('这个是状态222222>>>>...前台');
  //     break; case AppLifecycleState.paused: // 应用程序不可见，后台
  //     print('这个是状态33333>>>>...后台');
  //     break; case AppLifecycleState.detached:
  //     print('这个是状态44444>>>>...好像是断网了');
  //     break;  }
  // }



  @override
  void dispose() {
    // TODO: implement dispose
    _videoPlayerController.dispose();
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      // margin: EdgeInsets.all(16),
      // padding: EdgeInsets.all(16),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(12),
      // ),
      child:Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(0),
                  child: AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        VideoPlayer(_videoPlayerController),
                        // ClosedCaption(text: _videoPlayerController.value.caption.text,),
                        _ControlsOverlay(controller: _videoPlayerController),
                        VideoProgressIndicator(_videoPlayerController,
                            allowScrubbing: true)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10.0,
              right: (MediaQuery.of(context).size.width-240)/2,
              child: Container(
                // alignment: Alignment.bottomCenter,
                width: 200,
                child: Offstage(
                  offstage: false,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 16,
                      top: 6,
                    ),
                    child: Center(
                      child: CupertinoButton(
                        borderRadius: BorderRadius.circular(40),
                        onPressed: () {
                          // Navigator.of(context).pushNamedAndRemoveUntil('/camera', ModalRoute.withName('/homepage'));
                          // Navigator.pushNamedAndRemoveUntil(context, "/camera",ModalRoute.withName("/camera"));
                          // Navigator.popUntil(context, ModalRoute.withName('/home'));
                          NavigatorUtil.pushReplacementNamed(context, CameraPage(video0: widget.video0,));
                          // Navigator.of(context)
                          //     .push(new MaterialPageRoute(builder: (context) {
                          //   return new Camera();
                          // }));
                        },
                        color: Colors.blue,
                        child: Text('拍这个'),
                      ),
                    ),
                  ),
                ),
              )),

        ],
      )



    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key key, this.controller}) : super(key: key);

  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
            color: Colors.black26,
            child: Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100.0,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (context) {
              return [
                for (final speed in _examplePlaybackRates)
                  PopupMenuItem(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
