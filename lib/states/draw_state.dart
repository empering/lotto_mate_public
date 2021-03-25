import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:lotto_mate/api/lotto_api.dart';
import 'package:lotto_mate/commons/app_constant.dart';
import 'package:lotto_mate/models/buy.dart';
import 'package:lotto_mate/models/draw.dart';
import 'package:lotto_mate/services/buy_service.dart';
import 'package:lotto_mate/services/draw_service.dart';

class DrawState with ChangeNotifier {
  final LottoApi _lottoApi = LottoApi();

  final DrawService _drawService = DrawService();

  final BuyService _buyService = BuyService();

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Draw? _draw;

  Draw? get draw => _draw;

  DrawState() {
    _syncDbFromFirebase();
  }

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

  Future<void> syncDb(QueryDocumentSnapshot queryDocumentSnapshot) async {
    Draw d = Draw.fromFirestore(queryDocumentSnapshot.data()!);
    await _drawService.save(d);

    Buy buy = await _buyService.getByDrawId(d.id!);
    buy.picks?.forEach((pick) {
      if (pick.pickResult?.pickId == null) {
        _buyService.savePickResult(_buyService.calcPickResult(pick, d));
      }
    });
  }

  Future<int> getMaxDrawIdFromDb() async {
    var draw = await _drawService.getLast();
    return draw == null ? 0 : draw.id ?? 0;
  }

  void _syncDbFromFirebase() async {
    int maxDrawId = await this.getMaxDrawIdFromDb();
    if (maxDrawId < AppConstants().getThisWeekDrawId()) {
      QuerySnapshot snapshot = await _firebaseFirestore
          .collection('draws')
          .where('id', isGreaterThan: maxDrawId)
          .get();

      snapshot.docs.forEach((queryDocumentSnapshot) {
        this.syncDb(queryDocumentSnapshot);
      });
    }
  }
}
