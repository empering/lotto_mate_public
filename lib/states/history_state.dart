import 'package:flutter/foundation.dart';
import 'package:lotto_mate/commons/app_constant.dart';
import 'package:lotto_mate/models/draw_history.dart';
import 'package:lotto_mate/services/buy_service.dart';
import 'package:lotto_mate/services/draw_service.dart';

class HistoryState extends ChangeNotifier {
  final DrawService _drawService = DrawService();
  final BuyService _buyService = BuyService();

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

  setSearchDrawValues() {
    int maxDrawId = AppConstants().getThisWeekDrawId();
    _searchValues =
        List<String>.generate(maxDrawId, (index) => '${index + 1}')
            .toList();
  }

  setSearchType(String searchType) {
    if (_searchType == searchType) {
      print('searchType not changed');
    } else {
      _searchType = searchType;
      searchStartValue = searchType == 'all' ? '' : _searchValues.first;
      searchEndValue = searchType == 'all' ? '' : _searchValues.last;

      if (_searchType == 'all') {
        getHistory();
      }

      notifyListeners();
    }
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
