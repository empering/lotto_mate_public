import 'package:flutter/cupertino.dart';
import 'package:lotto_mate/models/search_filter.dart';

class StatState extends ChangeNotifier {
  final SearchFilter _searchFilter = SearchFilter();

  SearchFilter get searchFilter => _searchFilter;

  List<int> _list = [];

  List<int> get list => _list;

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
  }

  getData() async {
    var list = List.generate(45, (index) => index + 1);

    print(_searchFilter.searchType);
    print(_searchFilter.searchStartValue);
    print(_searchFilter.searchEndValue);

    await Future.delayed(Duration(seconds: 5));

    _list = list;

    notifyListeners();
  }
}
