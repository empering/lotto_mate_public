import 'package:flutter/foundation.dart';
import 'package:lotto_mate/models/buy.dart';
import 'package:lotto_mate/models/draw.dart';
import 'package:lotto_mate/models/prize.dart';
import 'package:lotto_mate/services/buy_service.dart';
import 'package:lotto_mate/services/draw_service.dart';

class HistoryViewState extends ChangeNotifier {
  final DrawService _drawService = DrawService();
  final BuyService _buyService = BuyService();

  final Buy _buy;
  Draw? _draw;

  num totAmount = 0;

  bool loading = true;

  HistoryViewState(this._buy);

  Buy get buy => _buy;

  Draw? get draw => _draw;

  getDraw() async {
    _draw = await _drawService.getDrawById(_buy.drawId);

    notifyListeners();
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
