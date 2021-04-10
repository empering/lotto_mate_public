import 'package:flutter/cupertino.dart';
import 'package:lotto_mate/models/search_filter.dart';
import 'package:lotto_mate/services/stat_service.dart';

enum StatType {
  NUMBER,
  COLOR,
  EVEN_ODD,
  SERIES,
  UNPICK,
}

class StatState extends ChangeNotifier {
  final StatService _statService;
  final SearchFilter _searchFilter = SearchFilter();
  final ScrollController _listViewController = ScrollController();
  late Function getData;
  StatType _statType = StatType.NUMBER;

  int _drawIdDiff = 10;

  StatState(this._statService) {
    getData = getNumberStats;
  }

  SearchFilter get searchFilter => _searchFilter;

  ScrollController get listViewController => _listViewController;

  List _stats = [];

  List get stats => _stats;

  bool get isOrderAsc => _searchFilter.isAsc;

  int get drawIdDiff => _drawIdDiff;

  set statType(StatType statType) {
    _statType = statType;

    switch (_statType) {
      case StatType.NUMBER:
        getData = getNumberStats;
        break;
      case StatType.COLOR:
        getData = getColorStats;
        break;
      case StatType.EVEN_ODD:
        getData = getEvenOddStats;
        break;
      case StatType.SERIES:
        getData = getSeriesStats;
        break;
      case StatType.UNPICK:
        getData = getUnpickStats;
        break;
      default:
        getData = getNumberStats;
    }
  }

  changeRecentDrawId(int drawIdDiff) {
    _drawIdDiff = drawIdDiff;
    _searchFilter.dirty = true;
    notify();
  }

  notify() {
    if (_searchFilter.isDirty) {
      _stats.clear();
      notifyListeners();

      getStats();

      _searchFilter.dirty = false;
    } else {
      notifyListeners();
    }

    _listViewController.animateTo(
      0.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  getStats({StatType? statType}) {
    if ((statType ?? _statType) != _statType) {
      this.statType = statType ?? _statType;
      _stats = [];
    }
    getData.call();
  }

  getNumberStats() async {
    var list = await _statService.getNumberStat(
      startId: int.parse(_searchFilter.searchStartValue),
      endId: int.parse(_searchFilter.searchEndValue),
      isWithBounsNumber: _searchFilter.isWithBounsNumber,
    );

    _stats = list;

    notifyListeners();
  }

  getColorStats() async {
    var list = await _statService.getColorStat(
      startId: int.parse(_searchFilter.searchStartValue),
      endId: int.parse(_searchFilter.searchEndValue),
      isWithBounsNumber: _searchFilter.isWithBounsNumber,
    );

    _stats = list;

    notifyListeners();
  }

  getEvenOddStats() async {
    var list = await _statService.getEvenOddStat(
      startId: int.parse(_searchFilter.searchStartValue),
      endId: int.parse(_searchFilter.searchEndValue),
      isWithBounsNumber: _searchFilter.isWithBounsNumber,
    );

    _stats = list;

    notifyListeners();
  }

  getSeriesStats() async {
    var list = await _statService.getSeriesStat(
      startId: int.parse(_searchFilter.searchStartValue),
      endId: int.parse(_searchFilter.searchEndValue),
    );

    _stats = list;

    notifyListeners();
  }

  getUnpickStats() async {
    var list = await _statService.getUnpickStat(
      startId: int.parse(_searchFilter.searchEndValue) - _drawIdDiff,
      endId: int.parse(_searchFilter.searchEndValue),
      isWithBounsNumber: _searchFilter.isWithBounsNumber,
    );

    _stats = list;

    notifyListeners();
  }
}
