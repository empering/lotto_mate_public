import 'package:flutter/cupertino.dart';
import 'package:lotto_mate/states/search_filter_state.dart';

class StatState extends ChangeNotifier {
  final SearchFilterState _searchFilterState;

  StatState(this._searchFilterState) {
    _searchFilterState.addListener(reloadData);
  }

  List<int> _list = [];

  List<int> get list => _list;

  bool get isOrderAsc => _searchFilterState.isAsc;

  reloadData() {
    _list.clear();
    notifyListeners();

    getData();
  }

  getData() async {
    var list = List.generate(45, (index) => index + 1);

    print(_searchFilterState.searchType);
    print(_searchFilterState.searchStartValue);
    print(_searchFilterState.searchEndValue);

    await Future.delayed(Duration(seconds: 5));

    _list = list;

    notifyListeners();
  }
}
