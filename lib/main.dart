
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_media/pages/login_page.dart';
import 'package:flutter_media/util/storage_manager.dart';
import 'package:flutter_media/util/common.dart';
import 'package:flutter_media/net/config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_media/util/utils.dart';
import 'package:oktoast/oktoast.dart';

import 'package:flutter/material.dart';

List<Locale> an = [
  const Locale('zh', 'CH'),
  const Locale('en', 'US'),
];
List<Locale> ios = [
  const Locale('en', 'US'),
  const Locale('zh', 'CH'),
];
List<CameraDescription> cameras;

void main() async {
  Config.env = Env.IOS_AUDIT;

// 运行主界面
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await StorageManager.init();
  await Utils.init();
  runApp(MyApp());
  //注册微信API
  // await fluwx.registerWxApi(
  //     appId: "wx888cb9d3ec086984",
  //     doOnAndroid: true,
  //     doOnIOS: true,
  //     universalLink: 'https://www.aireading.club/phms3app/');
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  // final model = PlayingLyric(quiet);
  String token;
  // String firstIn;
  // GlobalUserData globalUserData = GlobalUserData();

  final SystemUiOverlayStyle _style =
  SystemUiOverlayStyle(statusBarColor: Colors.transparent);
//  StreamSubscription exitLogin;
  @override
  void initState() {
    token = StorageManager.sharedPreferences.getString(Constant.access_Token);
    // firstIn = StorageManager.sharedPreferences.getString(Constant.firstIn);
    // token = 'f5cf27d2-f9ec-450f-97a0-690882fc8863';
  }





  @override
  void dispose() {
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            // ChineseCupertinoLocalizations.delegate,
          ],
          // supportedLocales: Platform.isIOS ? ios : an,

          // onGenerateRoute: Router.generateRoute,
          // navigatorKey: Router.navigatorKey,
          // navigatorObservers: [UmengAppAnalysis()],
          //定义路由
          //没有路由可以进行匹配的时候
          debugShowCheckedModeBanner: false,
          // onUnknownRoute: (RouteSettings setting) {
          //   String name = setting.name;
          //   print("onUnknownRoute:$name");
          //   return new MaterialPageRoute(builder: (context) {
          //     return new NotFoundPage();
          //   });
          // },
          routes: <String, WidgetBuilder>{
            // '/splash': (BuildContext context) => new SplashPage(),
            // '/firstin': (BuildContext context) => new FirstInPage(),
            '/login': (BuildContext context) => new LoginPage(),
            // '/playing': (BuildContext context) => new PlayingPage(),
          },
          title: '智阅媒体云',
          //debugShowCheckedModeBanner: false,
          builder: (context,widget){
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget
            );
          },
          home: Scaffold(
              body: LoginPage()
          ),
          theme: new ThemeData(
            appBarTheme: AppBarTheme(color: Color(0xff2CA687)),
            platform: TargetPlatform.iOS,
          ),
        ),
        backgroundColor: Colors.black54,
        textPadding:
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        radius: 20.0,
        position: ToastPosition.bottom,
        dismissOtherOnShow: true);
  }
}
