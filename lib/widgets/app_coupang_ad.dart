import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:lotto_mate/widgets/app_text_button.dart';
import 'package:lotto_mate/widgets/coupang_ad.dart';
import 'package:url_launcher/url_launcher.dart';

class AppCoupangAd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppAppBar('쿠팡파트너스 후원'),
        body: FutureBuilder(
          future: Future.delayed(Duration(milliseconds: 500)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              showCoupangDialog();
            } else {
              return Center(child: AppIndicator());
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.kissWinkHeart,
                    size: 80.0,
                  ),
                  Text(
                    '감사합니다!!',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Text('더 멋진 기능으로 보답하겠습니다!!'),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    width: MediaQuery.of(context).copyWith().size.width,
                    color: AppColors.backgroundAccent,
                    child: AppTextButton(
                      labelIcon: FontAwesomeIcons.ad,
                      labelText: ' 쿠팡파트너스',
                      onPressed: () async {
                        await launch('https://coupa.ng/bY8bq0');
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }

  showCoupangDialog() async {
    await Future.delayed(Duration(milliseconds: 10));
    Get.dialog(
      Center(
        child: Container(
          color: AppColors.backgroundAccent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CoupangHtmlAdView(
                CoupangHtmlAdConfig(
                  html: '''
                  <a href="https://coupa.ng/bY8bq0" target="_blank" referrerpolicy="unsafe-url"><img src="https://ads-partners.coupang.com/banners/477286?subId=lottomate&traceId=V0-301-879dd1202e5c73b2-I477286&w=320&h=480" alt=""></a>
                  ''',
                  width: 335,
                  height: 495,
                ),
              ),
              ButtonTheme(
                minWidth: 78.0,
                height: 34.0,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    AppTextButton(
                      labelIcon: Icons.cancel_outlined,
                      labelText: '닫기',
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
