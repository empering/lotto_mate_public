import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lotto_mate/commons/app_constant.dart';
import 'package:lotto_mate/models/buy.dart';
import 'package:lotto_mate/models/draw.dart';
import 'package:lotto_mate/services/buy_service.dart';
import 'package:lotto_mate/services/draw_service.dart';

class DataSyncState extends ChangeNotifier {
  final DrawService _drawService;

  final BuyService _buyService;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  bool _synchronizing = false;

  bool get synchronizing => _synchronizing;

  set synchronizing(bool value) {
    _synchronizing = value;
    notifyListeners();
  }

  DataSyncState(this._drawService, this._buyService) {
    _syncDbFromFirebase();
  }

  _syncDbFromFirebase() async {
    int maxDrawId = await this._getMaxDrawIdFromDb();
    if (maxDrawId < AppConstants().getThisWeekDrawId()) {
      synchronizing = true;

      QuerySnapshot snapshot = await _firebaseFirestore
          .collection('draws')
          .where('id', isGreaterThan: maxDrawId)
          .get();

      snapshot.docs.forEach((queryDocumentSnapshot) {
        this._syncDb(queryDocumentSnapshot);
      });

      synchronizing = false;
    }
  }

  _getMaxDrawIdFromDb() async {
    var draw = await _drawService.getLast();
    return draw == null ? 0 : draw.id ?? 0;
  }

  _syncDb(QueryDocumentSnapshot queryDocumentSnapshot) async {
    Draw d = Draw.fromFirestore(queryDocumentSnapshot.data());
    await _drawService.save(d);

    Buy buy = await _buyService.getByDrawId(d.id!);
    buy.picks?.forEach((pick) {
      if (pick.pickResult?.pickId == null) {
        _buyService.savePickResult(_buyService.calcPickResult(pick, d));
      }
    });
  }
}
