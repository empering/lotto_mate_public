import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/pages/buy/history.dart';
import 'package:lotto_mate/pages/buy/history_form.dart';
import 'package:lotto_mate/pages/buy/history_list.dart';
import 'package:lotto_mate/pages/home/home.dart';
import 'package:lotto_mate/pages/stats/stats.dart';
import 'package:lotto_mate/states/draw_state.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DrawState(),
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppAppBar('로또🤣💥'),
          backgroundColor: AppColors.background,
          body: FutureBuilder<QuerySnapshot>(
              future: _firebaseFirestore
                  .collection('draws')
                  .orderBy('id', descending: true)
                  .limit(10)
                  .get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  snapshot.data!.docs.forEach((element) {
                    Provider.of<DrawState>(context).test(element);
                  });

                  return TabBarView(
                    children: [
                      Home(),
                      History(),
                      HistoryForm(),
                      HistoryList(),
                      Stats(),
                    ],
                  );
                }

                return Center(child: CircularProgressIndicator());
              }),
          bottomNavigationBar: Container(
            color: AppColors.primary,
            height: 60,
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              indicatorColor: Colors.white,
              labelStyle: TextStyle(fontSize: 12.0, fontFamily: 'CookieRun'),
              tabs: [
                Tab(
                  icon: Icon(Icons.home_outlined),
                  text: '홈',
                  iconMargin: EdgeInsets.only(bottom: 3),
                ),
                Tab(
                  icon: Icon(Icons.fact_check_outlined),
                  text: '당첨결과',
                  iconMargin: EdgeInsets.only(bottom: 3),
                ),
                Tab(
                  icon: Icon(Icons.add_circle_outline),
                  iconMargin: EdgeInsets.only(bottom: 3),
                ),
                Tab(
                  icon: Icon(Icons.insights),
                  text: '번호생성',
                  iconMargin: EdgeInsets.only(bottom: 3),
                ),
                Tab(
                  icon: Icon(Icons.analytics_outlined),
                  text: '통계',
                  iconMargin: EdgeInsets.only(bottom: 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
