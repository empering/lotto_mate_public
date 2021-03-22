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
    int rank = 0;
    int count = 0;

    _draw?.numbers?.take(6).forEach((drawNumber) {
      if (pick.numbers!.contains(drawNumber)) {
        count++;
      }
    });

    switch (count) {
      case 6:
        rank = 1;
        break;

      case 5:
        {
          if (pick.numbers!.contains(_draw!.numbers!.last)) {
            rank = 2;
          } else {
            rank = 3;
          }
        }
        break;

      case 4:
        rank = 4;
        break;

      case 3:
        rank = 5;
        break;
    }

    pick.pickResult!.pickId = pick.id;
    pick.pickResult!.rank = rank;
    pick.pickResult!.rankName = rank > 0 ? '$rank등' : '낙첨';
    pick.pickResult!.amount = _draw?.prizes!
        .singleWhere(
          (p) => p.rank == rank,
          orElse: () => Prize(eachAmount: 0),
        )
        .eachAmount;

    _buyService.savePickResult(pick.pickResult!);
  }
}
