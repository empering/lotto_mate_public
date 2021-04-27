import 'package:flutter/foundation.dart';
import 'package:lotto_mate/models/buy.dart';
import 'package:lotto_mate/models/draw.dart';
import 'package:lotto_mate/services/buy_service.dart';
import 'package:lotto_mate/services/draw_service.dart';

enum HistoryViewType {
  VIEW,
  PREVIEW,
}

class HistoryViewState extends ChangeNotifier {
  final DrawService _drawService = DrawService();
  final BuyService _buyService = BuyService();

  late Buy _buy;
  Draw? _draw;

  num totAmount = 0;

  bool loading = true;

  Buy get buy => _buy;

  Draw? get draw => _draw;

  String appBarTitle = '나의 로또 히스토리';

  HistoryViewType _historyViewType = HistoryViewType.VIEW;

  HistoryViewType get historyViewType => _historyViewType;

  set historyViewType(HistoryViewType historyViewType) {
    _historyViewType = historyViewType;
    appBarTitle = _historyViewType == HistoryViewType.PREVIEW
        ? '나의 로또 결과 확인'
        : '나의 로또 히스토리';
  }

  setBuy(Buy buy) {
    _buy = buy;

    getDraw();
  }

  getDraw() async {
    _draw = await _drawService.getDrawById(_buy.drawId);
  }

  getPickResult() async {
    await this.getDraw();

    totAmount = 0;

    if (_draw != null) {
      _buy.picks?.forEach((pick) {
        if ((pick.pickResult?.pickId ?? 0) <= 0) {
          _setRank(pick);
        }

        if ((pick.pickResult?.amount ?? 0) > 0) {
          totAmount += pick.pickResult!.amount!;
        }
      });
    }

    loading = false;

    notifyListeners();
  }

  _setRank(Pick pick) {
    pick.pickResult = _buyService.calcPickResult(pick, _draw!);
    _buyService.savePickResult(pick.pickResult!);
  }
}
