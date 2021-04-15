import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:lotto_mate/api/lotto_api.dart';
import 'package:lotto_mate/commons/app_constant.dart';
import 'package:lotto_mate/models/draw.dart';

class HomeState with ChangeNotifier {
  final LottoApi _lottoApi;

  Draw? _draw;

  Draw? get draw => _draw;

  HomeState(this._lottoApi);

  void getDrawById({int? id}) async {
    if (id == null) {
      id = AppConstants().getThisWeekDrawId();
    }

    _draw = await _lottoApi.fetchLottoNumbers(id);
    notifyListeners();
  }

  void getPrevDraw() async {
    _draw = await _lottoApi.fetchLottoNumbers(_draw!.id! - 1);

    notifyListeners();
  }

  void getNextDraw() async {
    var nextDrawId = _draw!.id! + 1;
    var nextDrawDateTime = DateTime.parse(_draw!.drawDate!)
        .add(Duration(days: 7, hours: 11, minutes: 45));

    if (DateTime.now().isBefore(nextDrawDateTime.add(Duration(minutes: 5)))) {
      Get.snackbar('다음 회차 추첨 결과가 없습니다', '''
      $nextDrawId회차는 아직 추첨 전입니다. 
      ${nextDrawDateTime.year}-${nextDrawDateTime.month}-${nextDrawDateTime.day} 21:00 추첨 예정입니다.
      ''');
    } else {
      _draw = await _lottoApi.fetchLottoNumbers(nextDrawId);
    }

    notifyListeners();
  }
}
