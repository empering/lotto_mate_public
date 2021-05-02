import 'package:animations/animations.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lotto_mate/commons/app_box_decoration.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/pages/buy/history.dart';
import 'package:lotto_mate/pages/buy/history_form.dart';
import 'package:lotto_mate/pages/home/home.dart';
import 'package:lotto_mate/pages/recommend/recommend.dart';
import 'package:lotto_mate/pages/stats/stats.dart';
import 'package:lotto_mate/states/app_config_state.dart';
import 'package:lotto_mate/states/banner_ad_provider.dart';
import 'package:lotto_mate/states/buy_state.dart';
import 'package:lotto_mate/states/data_sync_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:lotto_mate/widgets/app_rewarded_ad.dart';
import 'package:lotto_mate/widgets/app_text_button.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int pageIndex = 0;
  var pages = [
    Home(),
    History(),
    HistoryForm(),
    Recommend(),
    Stats(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar('로또메이트'),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          action: SnackBarAction(
            label: '닫기',
            onPressed: () {},
          ),
          backgroundColor: AppColors.accent,
          content: Text(
            '뒤로가기를 한번 더 탭하면 앱이 종료되요.',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        child: Column(
          children: [
            Consumer<DataSyncState>(
              builder: (_, dataSyncState, __) {
                if (dataSyncState.synchronizing) {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppIndicator(),
                        SizedBox(height: 20.0),
                        Text('최신 로또 데이터를 수신 중이에요.'),
                        Text('처음 앱 구동시 조금 시간이 걸릴 수 있어요.'),
                      ],
                    ),
                  );
                }

                return Expanded(
                  child: PageTransitionSwitcher(
                    transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) {
                      return FadeThroughTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        child: child,
                      );
                    },
                    child: pages[pageIndex],
                  ),
                );
              },
            ),
            Consumer<BannerAdProvider>(
              builder: (_, bannerAd, __) {
                var adWidget = AdWidget(ad: bannerAd.newAd);
                return Container(
                  alignment: Alignment.center,
                  child: adWidget,
                  height: 72.0,
                  color: Colors.white,
                );
              },
            ),
          ],
        ),
      ),
      drawer: _makeDrawer(context),
      persistentFooterButtons: [
        Container(
          height: 25.0,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          width: MediaQuery.of(context).copyWith().size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Icon(FontAwesomeIcons.plusCircle),
                  Text(' 버튼을'),
                ],
              ),
              Text('눌러보세요!'),
            ],
          ),
        )
      ],
      bottomNavigationBar: _makeConvexBottomNavigationBar(),
    );
  }

  _makeDrawer(BuildContext context) {
    var listTiles = [
      ListTile(
        leading: FaIcon(FontAwesomeIcons.rocket),
        title: Text('앱 버전 정보'),
        trailing: Consumer<AppConfigState>(builder: (_, appConfigState, __) {
          return Text(
              'v${appConfigState.appVersion}+${appConfigState.appBuildNumber}');
        }),
      ),
      Wrap(
        children: [
          Consumer<AppConfigState>(builder: (_, appConfigState, __) {
            return SwitchListTile(
              secondary: appConfigState.appConfigValue
                  ? FaIcon(FontAwesomeIcons.bell)
                  : FaIcon(FontAwesomeIcons.bellSlash),
              title: Text('알림설정'),
              value: appConfigState.appConfigValue,
              onChanged: (value) {
                appConfigState.setConfigValue(value);
              },
            );
          }),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text(
              '알림설정 동의 하시면\n매주 토요일 오후 9시\n당첨결과 발표 시 알려드려요.',
              style: TextStyle(color: AppColors.background),
            ),
          )
        ],
      ),
      ListTile(
        leading: FaIcon(FontAwesomeIcons.cogs),
        title: Text('권한설정'),
        onTap: () {
          Get.defaultDialog(
            title: '확인해주세요',
            middleText: 'QR코드 스캔을 위해\n카메라 사용 권한이 필요해요.',
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppTextButton(
                    labelIcon: Icons.check_circle_outline,
                    labelText: '확인',
                    onPressed: () async {
                      Get.back();
                      context.read<BuyState>().appSetting();
                    },
                  ),
                  AppTextButton(
                    labelIcon: Icons.cancel_outlined,
                    labelText: '취소',
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              )
            ],
          );
        },
      ),
      ListTile(
        leading: FaIcon(FontAwesomeIcons.thumbsUp),
        title: Text('리뷰작성'),
        onTap: () {
          context.read<AppConfigState>().goMarket();
        },
      ),
      ListTile(
        leading: FaIcon(FontAwesomeIcons.shareAltSquare),
        title: Text('친구에게 알리기'),
        onTap: () {
          final RenderBox box = context.findRenderObject() as RenderBox;
          Share.share(
            '로또메이트와 함께 어디서나 쉽고 빠르게 나의 로또 번호를 확인하세요!',
            subject:
                'https://play.google.com/store/apps/details?id=com.lotto_mate',
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
          );
        },
      ),
      ListTile(
        leading: FaIcon(FontAwesomeIcons.ad),
        title: Text('광고보기 후원'),
        onTap: () {
          Get.to(() => AppRewardedAd());
        },
      ),
    ];

    return Drawer(
      elevation: 10.0,
      child: Column(
        children: [
          DrawerHeader(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: 25.0,
                    backgroundColor: AppColors.backgroundLight,
                    backgroundImage: AssetImage('assets/icon.png'),
                  ),
                  Text(
                    '로또메이트',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(color: AppColors.backgroundAccent),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 0.0,
              ),
              itemCount: listTiles.length,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (context, index) {
                return listTiles[index];
              },
            ),
          ),
        ],
      ),
    );
  }

  _makeConvexBottomNavigationBar() {
    return ConvexAppBar(
      style: TabStyle.fixed,
      backgroundColor: AppColors.accent,
      activeColor: AppColors.primary,
      color: AppColors.primary.withOpacity(0.7),
      curveSize: 55,
      top: -15,
      items: [
        TabItem(icon: FontAwesomeIcons.trophy, title: '당첨결과'),
        TabItem(icon: FontAwesomeIcons.history, title: '당첨이력'),
        TabItem(icon: FontAwesomeIcons.plusCircle, title: '번호등록'),
        TabItem(icon: FontAwesomeIcons.solidThumbsUp, title: '추천번호'),
        TabItem(icon: FontAwesomeIcons.solidChartBar, title: '통계분석'),
      ],
      onTap: (int i) {
        setState(() {
          pageIndex = i;
        });
      },
      onTabNotify: (index) {
        var intercept = index == 2;
        if (intercept) {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return Container(
                margin: const EdgeInsets.all(50.0),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: AppBoxDecoration().circular(),
                child: Wrap(
                  children: [
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.handPointer),
                      title: Text('직접 번호 등록'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.to(() => HistoryForm());
                      },
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.qrcode),
                      title: Text('QR 코드로 등록'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.to(() => HistoryForm(formType: HistoryFormType.QR));
                      },
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.grinStars),
                      title: Text('QR 코드로 확인'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.to(() =>
                            HistoryForm(formType: HistoryFormType.QR_CHECK));
                      },
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.timesCircle),
                      title: Text('닫기'),
                      onTap: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }

        return !intercept;
      },
    );
  }
}
