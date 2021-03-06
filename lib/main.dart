import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lotto_mate/api/lotto_api.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/commons/app_notification.dart';
import 'package:lotto_mate/commons/db_helper.dart';
import 'package:lotto_mate/pages/app.dart';
import 'package:lotto_mate/services/app_config_service.dart';
import 'package:lotto_mate/services/buy_service.dart';
import 'package:lotto_mate/services/draw_service.dart';
import 'package:lotto_mate/services/stat_service.dart';
import 'package:lotto_mate/states/app_config_state.dart';
import 'package:lotto_mate/states/buy_state.dart';
import 'package:lotto_mate/states/data_sync_state.dart';
import 'package:lotto_mate/states/draw_list_state.dart';
import 'package:lotto_mate/states/history_list_state.dart';
import 'package:lotto_mate/states/history_state.dart';
import 'package:lotto_mate/states/history_view_state.dart';
import 'package:lotto_mate/states/home_state.dart';
import 'package:lotto_mate/states/recommend_state.dart';
import 'package:lotto_mate/states/stat_state.dart';
import 'package:lotto_mate/widgets/banner_ad_provider.dart';
import 'package:lotto_mate/widgets/interstitial_ad_provider.dart';
import 'package:lotto_mate/widgets/rewarded_ad_provider.dart';
import 'package:provider/provider.dart';

enum StoreType {
  PLAY_STORE,
  ONE_STORE,
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

getBuildNumber() async {
  RemoteConfig remoteConfig = RemoteConfig.instance;
  remoteConfig.settings.fetchTimeout = Duration(seconds: 60);

  await remoteConfig.fetchAndActivate();

  return remoteConfig.getString('build_number');
}

Future<dynamic> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.initDatabase();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();

  await AppNotification.initialize();

  return await getBuildNumber();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.initDatabase();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();

  await AppNotification.initialize();

  String buildNumer = await getBuildNumber();

  runApp(MyApp(
    isReleases: kReleaseMode,
    buildNumer: buildNumer,
  ));
}

class MyApp extends StatelessWidget {
  final isReleases;
  final buildNumer;
  final StoreType storeType;

  MyApp({
    required this.isReleases,
    this.buildNumer,
    this.storeType = StoreType.PLAY_STORE,
  });

  @override
  Widget build(BuildContext context) {
    LottoApi lottoApi = LottoApi();
    AppConfigService appConfigService = AppConfigService();
    DrawService drawService = DrawService();
    BuyService buyService = BuyService();
    StatService statService = StatService();

    var bannerAdProvider = BannerAdProvider(isReleases: isReleases);
    var interstitialAdProvider = InterstitialAdProvider(isReleases: isReleases);
    var rewardedAdProvider = RewardedAdProvider(isReleases: isReleases);

    var historyState = HistoryState(drawService, buyService);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: AppConfigState(appConfigService, storeType)
              ..initialize(buildNumer)),
        ChangeNotifierProvider.value(
            value: DataSyncState(drawService, buyService)),
        ChangeNotifierProvider.value(value: HomeState(lottoApi, drawService)),
        ChangeNotifierProvider.value(value: DrawListState(drawService)),
        ChangeNotifierProvider.value(
            value: BuyState(buyService, drawService, historyState)),
        ChangeNotifierProvider.value(value: historyState),
        ChangeNotifierProvider.value(value: HistoryListState(buyService)),
        ChangeNotifierProvider.value(value: HistoryViewState()),
        ChangeNotifierProvider.value(
            value: RecommendState(interstitialAdProvider, rewardedAdProvider)),
        ChangeNotifierProvider.value(value: StatState(statService)),
        Provider.value(value: bannerAdProvider),
        Provider.value(value: interstitialAdProvider),
        Provider.value(value: rewardedAdProvider),
      ],
      child: GetMaterialApp(
        title: '???????????????',
        defaultTransition: Transition.size,
        transitionDuration: Duration(milliseconds: 500),
        theme: ThemeData(
          // brightness: Brightness.dark,
          primaryColor: AppColors.primary,
          accentColor: AppColors.primary,
          backgroundColor: AppColors.backgroundLight,
          scaffoldBackgroundColor: AppColors.backgroundLight,
          dialogBackgroundColor: AppColors.backgroundAccent,
          canvasColor: AppColors.backgroundLight,
          cardColor: AppColors.backgroundLight,
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
            subtitle1: TextStyle(),
            bodyText1: TextStyle(),
            bodyText2: TextStyle(color: AppColors.accent),
          ).apply(bodyColor: AppColors.primary),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: AppColors.primary,
            ),
          ),
          iconTheme: IconThemeData(
            color: AppColors.primary,
          ),
        ),
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: [const Locale('ko', 'KR')],
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
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
