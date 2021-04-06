import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lotto_mate/models/buy.dart';
import 'package:lotto_mate/services/buy_service.dart';

class BuyHistoryState with ChangeNotifier {
  final BuyService _buyService = BuyService();

  final ScrollController _listViewController = ScrollController();

  ScrollController get listViewController => _listViewController;

  List<Buy> _buys = [];

  List<Buy> get buys => _buys;

  set setBuys(List<Buy> buys) => _buys = buys;

  final int limit = 10;
  int offset = 0;
  bool hasMore = false;

  BuyHistoryState() {
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

  void getAll() async {
    _buys = await _buyService.getAll();

    notifyListeners();
  }

  void getBuys() async {
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
