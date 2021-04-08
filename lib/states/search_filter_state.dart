import 'package:flutter/cupertino.dart';
import 'package:lotto_mate/commons/app_constant.dart';

enum SearchType {
  ALL,
  DRAWS,
}

enum Order { ASC, DESC }

class SearchFilterState extends ChangeNotifier {
  SearchType _searchType = SearchType.ALL;
  Order _order = Order.ASC;
  List<String> _searchValues = [];
  bool _isWithBounsNumber = false;
  String searchStartValue = '';
  String searchEndValue = '';

  SearchType get searchType => _searchType;

  Order get order => _order;

  List<String> get searchValues => _searchValues;

  bool get isWithBounsNumber => _isWithBounsNumber;

  bool get isDraw => _searchType == SearchType.DRAWS;

  bool get isAsc => _order == Order.ASC;

  SearchFilterState() {
    setSearchDrawValues();
  }

  set isWithBounsNumber(bool value) {
    _isWithBounsNumber = value;

    notifyListeners();
  }

  setSearchDrawValues() {
    int maxDrawId = AppConstants().getThisWeekDrawId();
    _searchValues =
        List<String>.generate(maxDrawId, (index) => '${index + 1}').toList();
    searchStartValue = _searchValues.first;
    searchEndValue = _searchValues.last;
  }

  setSearchType(SearchType searchType) {
    _searchType = searchType;
    searchStartValue = _searchValues.first;
    searchEndValue = _searchValues.last;

    print('setSearchType');
    notifyListeners();
  }

  setOrder(Order order) {
    _order = order;

    notifyListeners();
  }
}
