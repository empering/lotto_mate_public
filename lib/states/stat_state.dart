import 'package:flutter/cupertino.dart';
import 'package:lotto_mate/models/search_filter.dart';
import 'package:lotto_mate/models/stat.dart';
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

  StatState(this._statService) {
    getData = getNumberStats;
  }

  SearchFilter get searchFilter => _searchFilter;

  ScrollController get listViewController => _listViewController;

  List<Stat> _stats = [];

  List<Stat> get stats => _stats;

  bool get isOrderAsc => _searchFilter.isAsc;

  set statType(StatType statType) {
    _statType = statType;

    switch (_statType) {
      case StatType.NUMBER:
        getData = getNumberStats;
        break;
      default:
        getData = getNumberStats;
    }
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

  getStats() {
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
}
