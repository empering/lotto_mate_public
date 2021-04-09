import 'package:flutter/cupertino.dart';
import 'package:lotto_mate/models/search_filter.dart';
import 'package:lotto_mate/models/stat.dart';
import 'package:lotto_mate/services/stat_service.dart';

class StatState extends ChangeNotifier {
  final StatService _statService;
  final SearchFilter _searchFilter = SearchFilter();
  final ScrollController _listViewController = ScrollController();

  StatState(this._statService);

  SearchFilter get searchFilter => _searchFilter;

  ScrollController get listViewController => _listViewController;

  List<Stat> _list = [];

  List<Stat> get list => _list;

  bool get isOrderAsc => _searchFilter.isAsc;

  notify() {
    if (_searchFilter.isDirty) {
      _list.clear();
      notifyListeners();

      getData();

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

  getData() async {
    var list = await _statService.getNumberStat(
      startId: int.parse(_searchFilter.searchStartValue),
      endId: int.parse(_searchFilter.searchEndValue),
      isWithBounsNumber: _searchFilter.isWithBounsNumber,
    );

    _list = list;

    notifyListeners();
  }
}
