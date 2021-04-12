import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/commons/db_helper.dart';
import 'package:lotto_mate/pages/app.dart';
import 'package:lotto_mate/services/buy_service.dart';
import 'package:lotto_mate/services/draw_service.dart';
import 'package:lotto_mate/services/stat_service.dart';
import 'package:lotto_mate/states/banner_ad_provider.dart';
import 'package:lotto_mate/states/buy_history_state.dart';
import 'package:lotto_mate/states/buy_state.dart';
import 'package:lotto_mate/states/draw_list_state.dart';
import 'package:lotto_mate/states/history_state.dart';
import 'package:lotto_mate/states/recommend_state.dart';
import 'package:lotto_mate/states/stat_state.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.initDatabase();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  var firebaseMessaging = FirebaseMessaging.instance;

  await firebaseMessaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    var notification = message.notification;

    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            // icon: 'ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
            ticker: 'ticker',
            // other properties...
          ),
        ),
      );
    }
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DrawService drawService = DrawService();
    BuyService buyService = BuyService();
    StatService statService = StatService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: DrawListState(drawService)),
        ChangeNotifierProvider.value(value: BuyState(buyService)),
        ChangeNotifierProvider.value(value: BuyHistoryState(buyService)),
        ChangeNotifierProvider.value(value: RecommendState()),
        ChangeNotifierProvider.value(
            value: HistoryState(drawService, buyService)),
        ChangeNotifierProvider.value(value: StatState(statService)),
        Provider.value(value: BannerAdProvider()),
      ],
      child: GetMaterialApp(
        title: 'Lotto Mate',
        defaultTransition: Transition.size,
        transitionDuration: Duration(milliseconds: 500),
        theme: ThemeData(
          // brightness: Brightness.dark,
          primaryColor: AppColors.primary,
          accentColor: AppColors.accent,
          backgroundColor: AppColors.backgroundLight,
          scaffoldBackgroundColor: AppColors.backgroundLight,
          dividerColor: AppColors.accent,
          fontFamily: 'CookieRun',
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.backgroundAccent,
          ),
          tabBarTheme: TabBarTheme(
            labelColor: AppColors.primary,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
          textTheme: TextTheme(
            headline1: TextStyle(
              color: AppColors.primary,
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
              wordSpacing: 1,
              shadows: [
                Shadow(
                  offset: Offset(5.0, 5.0),
                  color: AppColors.accent,
                ),
              ],
            ),
            bodyText1: TextStyle(),
            bodyText2: TextStyle(color: AppColors.accent),
          ).apply(bodyColor: AppColors.primary),
          iconTheme: IconThemeData(
            color: AppColors.primary,
          ),
        ),
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: [const Locale('ko', 'KR')],
        home: AppInit(),
      ),
    );
  }
}

class AppInit extends StatefulWidget {
  @override
  _AppInitState createState() => _AppInitState();
}

class _AppInitState extends State<AppInit> {
  // final Future<FirebaseApp> _initFirebase = Firebase.initializeApp();
  // final Future<Database?> _initDatabase = DbHelper.initDatabase();

  @override
  Widget build(BuildContext context) {
    return App();
    // return FutureBuilder(
    //   // future: _initialization,
    //   // future: _initDatabase,
    //   future: Future.wait([_initDatabase]),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasError) {
    //       return Text("");
    //     }
    //
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       return App();
    //     }
    //
    //     return Center(child: AppIndicator());
    //   },
    // );
  }
}
