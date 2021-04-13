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
import 'package:lotto_mate/states/draw_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
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
    return ChangeNotifierProvider(
      create: (_) => DrawState()..getDrawById(),
      child: Scaffold(
        appBar: AppAppBar('로또🤣💥'),
        body: Column(
          children: [
            Expanded(
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
        bottomNavigationBar: _makeConvexBottomNavigationBar(),
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
