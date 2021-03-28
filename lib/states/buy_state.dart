import 'package:flutter/foundation.dart';
import 'package:lotto_mate/commons/app_constant.dart';
import 'package:lotto_mate/models/buy.dart';
import 'package:lotto_mate/services/buy_service.dart';

class BuyState with ChangeNotifier {
  final BuyService _buyService = BuyService();

  final int thisWeekDrawId = AppConstants().getThisWeekDrawId();

  Buy? _buy;

  bool _canSave = false;

  Buy? get buy => _buy;

  set setBuy(Buy buy) {
    _buy = buy;

    notifyListeners();
  }

  bool get getCanSave => _canSave;

  _setCanSave() {
    _canSave = true;

    _buy!.picks!.forEach((pick) {
      var notEmptyNumberCount = 0;
      pick.numbers?.forEach((int? number) {
        if (number != null && number > 0) {
          notEmptyNumberCount++;
        }
      });

      if (notEmptyNumberCount < 6) {
        _canSave = false;
      }
    });
  }

  BuyState() {
    _initBuy();
  }

  set setDrawId(int drawId) {
    this._buy!.drawId = drawId;
    notifyListeners();
  }

  setPickedDefault() {
    _buy!.picks!.forEach((pick) {
      pick.isPicked = false;
    });
    notifyListeners();
  }

  setPickedLast() {
    setPickedDefault();
    _buy!.picks!.last.isPicked = true;
    notifyListeners();
  }

  setPickedThis(Pick pick) {
    setPickedDefault();
    _buy!.picks!.forEach((p) {
      if (identical(p, pick)) {
        p.isPicked = true;
      }
    });

    notifyListeners();
  }

  getPicked() => _buy!.picks!.lastWhere((pick) => pick.isPicked!);

  togglePickType(Pick pick) {
    _buy!.picks!.forEach((p) {
      if (identical(p, pick)) {
        p.type = p.type == 'q' ? 'm' : 'q';
      }
    });

    notifyListeners();
  }

  pickNumber(int number) {
    Pick pick = this.getPicked();

    var notEmptyNumberCount = 0;
    var isNotDuplicated = true;

    pick.numbers!.forEach((int? value) {
      if (value != null && value > 0) {
        if (value == number) {
          isNotDuplicated = false;
        }

        notEmptyNumberCount++;
      }
    });

    if (notEmptyNumberCount < 6 && isNotDuplicated) {
      pick.numbers![notEmptyNumberCount] = number;

      if (notEmptyNumberCount > 1) {
        _sortNumbers(pick.numbers!);
      }
    }

    _setCanSave();
    notifyListeners();
  }

  popNumber(Pick pick, int? number) {
    this.setPickedThis(pick);
    if (number != null) {
      var numberIndex = pick.numbers!.indexOf(number);
      pick.numbers![numberIndex] = null;

      _sortNumbers(pick.numbers!);

      _setCanSave();
    }

    notifyListeners();
  }

  addNewPick() {
    _buy!.picks!.add(Pick.generate(isPicked: true));

    _setCanSave();
    notifyListeners();
  }

  popPick() {
    if (_buy!.picks!.length == 1) {
      _buy!.picks![0].numbers = List.filled(6, null, growable: false);
    } else {
      _buy!.picks!.removeLast();
    }

    _setCanSave();
    this.setPickedLast();
  }

  void insert() {
    _buyService.save(_buy!);
    _initBuy();

    notifyListeners();
  }

  _initBuy() {
    _buy = Buy(
        drawId: AppConstants().getThisWeekDrawId() + 1,
        picks: [Pick.generate(isPicked: true)]);
  }

  _sortNumbers(List<int?> numbers) {
    numbers.sort((int? a, int? b) {
      if (a == null) {
        return 1;
      } else if (b == null) {
        return -1;
      } else {
        return a.compareTo(b);
      }
    });
  }
}
