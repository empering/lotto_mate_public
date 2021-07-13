import 'package:flutter/foundation.dart';
import 'package:lotto_mate/commons/app_constant.dart';
import 'package:lotto_mate/models/buy.dart';
import 'package:lotto_mate/models/draw.dart';
import 'package:lotto_mate/services/buy_service.dart';
import 'package:lotto_mate/services/draw_service.dart';
import 'package:lotto_mate/states/history_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

enum HistoryFormType {
  MANUAL,
  QR,
  QR_CHECK,
}

class BuyState with ChangeNotifier {
  final BuyService _buyService;

  final DrawService _drawService;

  final HistoryState _historyState;

  BuyState(this._buyService, this._drawService, this._historyState) {
    _initBuy();
  }

  final int thisWeekDrawId = AppConstants().getThisWeekDrawId();

  HistoryFormType _formType = HistoryFormType.MANUAL;

  Buy? _buy;

  bool _canSave = false;

  bool _okQr = false;

  String appBarTitle = '로또 번호 등록';

  PermissionStatus _cameraPermissionStatus = PermissionStatus.granted;

  HistoryFormType get formType => _formType;

  set formType(HistoryFormType formType) {
    _formType = formType;
    _buy!.picks = [];

    if (_formType == HistoryFormType.MANUAL) {
      _initBuy();
    } else {
      _getQrData();
    }

    if (_formType == HistoryFormType.QR_CHECK) {
      this.appBarTitle = '로또 번호 확인';
    }
  }

  Buy? get buy => _buy;

  set setBuy(Buy buy) {
    _buy = buy;

    notifyListeners();
  }

  bool get getCanSave {
    if (_formType == HistoryFormType.QR ||
        _formType == HistoryFormType.QR_CHECK) {
      return _canSave && _okQr;
    }
    return _canSave;
  }

  bool get okQr => _okQr;

  PermissionStatus get cameraPermissionStatus => _cameraPermissionStatus;

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

  scanQr() {
    _getQrData();
  }

  _getQrData() async {
    _okQr = false;
    _cameraPermissionStatus = await _checkPermission();
    if (_cameraPermissionStatus.isGranted) {
      String? qrCodeData = await scanner.scan();
      print(qrCodeData);
      // http://m.dhlottery.co.kr/?v=0933m020719324142m091819354144m091116264145m161921253233m0708161935431964500808
      // http://m.dhlottery.co.kr/?v=0937q030416354143q131417182435q101619212428n000000000000n0000000000001053764487
      if (qrCodeData != null &&
          qrCodeData.indexOf('http://m.dhlottery.co.kr/?v=') >= 0) {
        _okQr = true;
        String qrData = qrCodeData.split('v=')[1];
        this.setBuy = Buy.fromQr(qrData);
      }
    }

    _setCanSave();
    notifyListeners();
  }

  _checkPermission() async {
    return await Permission.camera.request();
  }

  appSetting() async {
    if (_cameraPermissionStatus.isPermanentlyDenied) {
      await openAppSettings();
    }

    _cameraPermissionStatus = await _checkPermission();
    notifyListeners();
  }

  insert({bool isReset = true}) async {
    var newBuy = await _buyService.save(_buy!);

    var draw = await _drawService.getDrawById(newBuy.drawId);

    if (draw != null) {
      await Future.forEach<Pick>(newBuy.picks!, (pick) async {
        await _setRank(pick, draw);
      });
    }

    await _historyState.getHistory();

    if (isReset) {
      _initBuy();
    } else {
      _buy = newBuy;
    }

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

  _setRank(Pick pick, Draw draw) async {
    pick.pickResult = _buyService.calcPickResult(pick, draw);
    await _buyService.savePickResult(pick.pickResult!);
  }
}
