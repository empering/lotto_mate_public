import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lotto_mate/commons/app_colors.dart';
import 'package:lotto_mate/states/rewarded_ad_provider.dart';
import 'package:lotto_mate/widgets/app_app_bar.dart';
import 'package:lotto_mate/widgets/app_indicator.dart';
import 'package:lotto_mate/widgets/app_text_button.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AppRewardedAd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var rewardedAdProvider = context.watch<RewardedAdProvider>();

    return Scaffold(
        appBar: AppAppBar('광고보기 후원'),
        body: FutureBuilder(
          future: Future.wait([
            rewardedAdProvider.rewardedAd.load(),
            rewardedAdProvider.waitLoaded(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              rewardedAdProvider.showAd();
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
}
