import 'package:flutter/foundation.dart';
import 'package:lotto_mate/commons/app_constant.dart';
import 'package:lotto_mate/models/draw_history.dart';
import 'package:lotto_mate/services/buy_service.dart';
import 'package:lotto_mate/services/draw_service.dart';

class HistoryState extends ChangeNotifier {
  final DrawService _drawService;
  final BuyService _buyService;

  HistoryState(this._drawService, this._buyService) {
    setSearchDrawValues();
  }

  // 나의 히스토리
  DrawHistory? _myHistory;

  DrawHistory? get myHistory => _myHistory;

  // 전체 히스토리
  DrawHistory? _drawHistory;

  DrawHistory? get drawHistory => _drawHistory;

  String _searchType = 'all';
  List<String> _searchValues = [];
  String searchStartValue = '';
  String searchEndValue = '';

  String get searchType => _searchType;

  List<String> get searchValues => _searchValues;

  bool _isMyHistory = true;

  bool get isMyHistory => _isMyHistory;

  set isMyHistory(bool value) {
    _isMyHistory = value;

    notifyListeners();
  }

  setSearchDrawValues() {
    int maxDrawId = AppConstants().getThisWeekDrawId();
    _searchValues =
        List<String>.generate(maxDrawId, (index) => '${index + 1}').toList();
  }

  setSearchType(String searchType) {
    _searchType = searchType;
    searchStartValue = _searchValues.first;
    searchEndValue = _searchValues.last;
  }

  getHistory() async {
    DrawHistory drawHistory = await _drawService.getDrawsSummary(
      startId: _searchType == 'all' ? null : int.parse(searchStartValue),
      endId: _searchType == 'all' ? null : int.parse(searchEndValue),
    );

    DrawHistory myHistory = await _buyService.getBuySummary(
      startId: _searchType == 'all' ? null : int.parse(searchStartValue),
      endId: _searchType == 'all' ? null : int.parse(searchEndValue),
    );

    _drawHistory = drawHistory;
    _myHistory = myHistory;

    notifyListeners();
  }
}
