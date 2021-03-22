import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:lotto_mate/api/lotto_api.dart';
import 'package:lotto_mate/commons/app_constant.dart';
import 'package:lotto_mate/models/draw.dart';
import 'package:lotto_mate/services/draw_service.dart';

class DrawState with ChangeNotifier {
  final LottoApi _lottoApi = LottoApi();

  final DrawService _drawService = DrawService();

  Draw? _draw;

  Draw? get draw => _draw;

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
    var nextDrawDateTime =
        DateTime.parse(_draw!.drawDate!).add(Duration(days: 7, hours: 11, minutes: 45));

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

  Future<void> test(QueryDocumentSnapshot element) async {
    Draw d = Draw.fromFirestore(element.data()!);
    Draw? d2 = await _drawService.getDrawById(d.id);

    if (d2 == null) {
      _drawService.save(d);

    }
  }
}
