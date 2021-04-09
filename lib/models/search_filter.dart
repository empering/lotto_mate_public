import 'package:lotto_mate/commons/app_constant.dart';

enum SearchType {
  ALL,
  DRAWS,
}

enum Order { ASC, DESC }

class SearchFilter {
  bool _dirty = false;
  SearchType _searchType = SearchType.ALL;
  Order _order = Order.ASC;
  List<String> _searchValues = [];
  bool _isWithBounsNumber = false;
  String searchStartValue = '';
  String searchEndValue = '';

  SearchType get searchType => _searchType;

  Order get order => _order;

  List<String> get searchValues => _searchValues;

  bool get isDirty => _dirty;

  bool get isDraw => _searchType == SearchType.DRAWS;

  bool get isAsc => _order == Order.ASC;

  bool get isWithBounsNumber => _isWithBounsNumber;

  SearchFilter() {
    setSearchDrawValues();
  }

  setSearchDrawValues() {
    int maxDrawId = AppConstants().getThisWeekDrawId();
    _searchValues =
        List<String>.generate(maxDrawId, (index) => '${index + 1}').toList();
    searchStartValue = _searchValues.first;
    searchEndValue = _searchValues.last;
  }

  set dirty(bool value) {
    _dirty = value;
  }

  setSearchType(SearchType searchType) {
    _searchType = searchType;
    if (SearchType.ALL == searchType) {
      _dirty = _dirty ||
          searchStartValue != _searchValues.first ||
          searchEndValue != _searchValues.last;

      searchStartValue = _searchValues.first;
      searchEndValue = _searchValues.last;
    }
  }

  setOrder(Order order) {
    _order = order;
  }

  set isWithBounsNumber(bool value) {
    if (_isWithBounsNumber != value) {
      _dirty = true;
      _isWithBounsNumber = value;
    }
  }
}
