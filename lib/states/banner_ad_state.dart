import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdState with ChangeNotifier {
  late BannerAd _ad;

  BannerAdState() {
    _ad = BannerAd(
      size: AdSize.banner,
      adUnitId: BannerAd.testAdUnitId,
      listener: AdListener(),
      request: AdRequest(),
    )..load();
  }

  AdWithView get ad => _ad;
}
