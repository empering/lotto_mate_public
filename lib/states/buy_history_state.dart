import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lotto_mate/models/buy.dart';
import 'package:lotto_mate/services/buy_service.dart';

class BuyHistoryState with ChangeNotifier {
  final BuyService _buyService;

  final ScrollController _listViewController = ScrollController();

  ScrollController get listViewController => _listViewController;

  List<Buy> _buys = [];

  List<Buy> get buys => _buys;

  set setBuys(List<Buy> buys) => _buys = buys;

  List<BannerAd> _ads = [];

  List<BannerAd> get ads => _ads;

  final int limit = 10;
  int offset = 0;
  bool hasMore = false;

  BuyHistoryState(this._buyService) {
    this._listViewController.addListener(() async {
      if (this._listViewController.position.pixels ==
              this.listViewController.position.maxScrollExtent &&
          this.hasMore) {
        await Future.delayed(Duration(milliseconds: 500));
        this.offset = buys.length;
        this.getBuys();
      }
    });
  }

  void getBuys({bool isFirst = false}) async {
    if (isFirst) {
      offset = 0;
      hasMore = false;
      _buys = [];
      _ads = [];
    }

    var buys = await _buyService.getAll(limit: limit, offset: offset);

    _buys.addAll(buys);

    if (buys.length == limit) {
      hasMore = true;
    } else {
      hasMore = false;
    }

    notifyListeners();
  }
}
