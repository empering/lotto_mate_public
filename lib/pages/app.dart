import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/pages/buy/history.dart';
import 'package:lotto_mate/pages/buy/history_form.dart';
import 'package:lotto_mate/pages/home/home.dart';
import 'package:lotto_mate/pages/recommend/recommend.dart';
import 'package:lotto_mate/pages/stats/stats.dart';
import 'package:lotto_mate/states/draw_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DrawState()..getDrawById(),
      child: Scaffold(
        appBar: AppAppBar('로또🤣💥'),
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Home(),
            History(),
            HistoryForm(),
            Recommend(),
            Stats(),
          ],
        ),
        bottomNavigationBar: _makeConvexBottomNavigationBar(),
      ),
    );
  }

  _makeConvexBottomNavigationBar() {
    return ConvexAppBar(
      controller: _tabController,
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
      onTabNotify: (index) {
        var intercept = index == 2;
        if (intercept) {
          Get.to(HistoryForm());
        }

        return !intercept;
      },
    );
  }
}
