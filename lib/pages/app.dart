import 'package:animations/animations.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
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
import 'package:lotto_mate/states/banner_ad_provider.dart';
import 'package:lotto_mate/states/buy_state.dart';
import 'package:lotto_mate/states/data_sync_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:lotto_mate/widgets/app_rewarded_ad.dart';
import 'package:lotto_mate/widgets/app_text_button.dart';
import 'package:provider/provider.dart';

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
      appBar: AppAppBar('로또🤣💥'),
      body: Column(
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
              );
            },
          ),
        ],
      ),
      drawer: _makeDrawer(context),
      bottomNavigationBar: _makeConvexBottomNavigationBar(),
    );
  }

  _makeDrawer(BuildContext context) {
    var listTiles = [
      ListTile(
        leading: FaIcon(FontAwesomeIcons.rocket),
        title: Text('앱 버전 정보'),
        trailing: Text('v1.0.1'),
      ),
      ListTile(
        leading: FaIcon(FontAwesomeIcons.bell),
        title: Text('알림설정'),
        onTap: () {
          Get.defaultDialog(
            title: '이런...',
            middleText: '알림설정 기능은 아직 준비중이에요.',
          );
        },
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
      // ListTile(
      //   leading: FaIcon(FontAwesomeIcons.thumbsUp),
      //   title: Text('리뷰작성'),
      //   onTap: () {},
      // ),
      // ListTile(
      //   leading: FaIcon(FontAwesomeIcons.shareAltSquare),
      //   title: Text('친구에게 알리기'),
      //   onTap: () {},
      // ),
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
      // controller: _tabController,
      style: TabStyle.textIn,
      backgroundColor: AppColors.primary,
      activeColor: AppColors.light,
      color: AppColors.sub,
      items: [
        TabItem(icon: Icons.home_outlined, title: '홈'),
        TabItem(icon: Icons.fact_check_outlined, title: '당첨결과'),
        TabItem(
          icon: Icon(
            Icons.add_circle_outline,
            color: AppColors.accent,
          ),
          title: '등록',
        ),
        TabItem(icon: Icons.auto_awesome, title: '번호생성'),
        TabItem(icon: Icons.analytics_outlined, title: '통계'),
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
                        Get.to(HistoryForm());
                      },
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.qrcode),
                      title: Text('QR 코드로 등록'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.to(HistoryForm(formType: HistoryFormType.QR));
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
