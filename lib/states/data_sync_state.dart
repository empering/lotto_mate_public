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

      await Future.forEach<QueryDocumentSnapshot>(snapshot.docs,
          (queryDocumentSnapshot) async {
        await this._syncDb(queryDocumentSnapshot);
      });

      synchronizing = false;

      notifyListeners();
    }
  }

  _getMaxDrawIdFromDb() async {
    var draw = await _drawService.getLast();
    return draw == null ? 0 : draw.id ?? 0;
  }

  _syncDb(QueryDocumentSnapshot queryDocumentSnapshot) async {
    Draw d = Draw.fromFirestore(queryDocumentSnapshot.data());

    print(d.id);
    await _drawService.save(d);

    Buy buy = await _buyService.getByDrawId(d.id!);

    if (buy.picks != null) {
      await Future.forEach<Pick>(buy.picks!, (pick) async {
        if (pick.pickResult?.pickId == null) {
          await _buyService.savePickResult(_buyService.calcPickResult(pick, d));
        }
      });
    }
  }
}
