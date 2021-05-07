import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lotto_mate/models/buy.dart';
import 'package:lotto_mate/services/buy_service.dart';

class HistoryListState with ChangeNotifier {
  final BuyService _buyService;

  final ScrollController _listViewController = ScrollController();

  ScrollController get listViewController => _listViewController;

  List<Buy> _buys = [];

  List<Buy> get buys => _buys;

  set setBuys(List<Buy> buys) => _buys = buys;

  List<dynamic> _ads = [];

  List<dynamic> get ads => _ads;

  final int limit = 10;
  int offset = 0;
  bool hasMore = false;
  bool isLoading = false;

  HistoryListState(this._buyService) {
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

    isLoading = true;

    var buys = await _buyService.getAll(limit: limit, offset: offset);

    _buys.addAll(buys);

    if (buys.length == limit) {
      hasMore = true;
    } else {
      hasMore = false;
    }

    isLoading = false;

    notifyListeners();
  }

  deleteBuy(Buy buy) async {
    await _buyService.delete(buy);

    _buys.remove(buy);

    notifyListeners();
  }
}
