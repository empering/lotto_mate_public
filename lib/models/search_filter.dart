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
  bool _isWithBounsNumber = true;
  String _searchStartValue = '';
  String _searchEndValue = '';

  SearchType get searchType => _searchType;

  Order get order => _order;

  List<String> get searchValues => _searchValues;

  bool get isDirty => _dirty;

  bool get isAll => _searchType == SearchType.ALL;

  bool get isAsc => _order == Order.ASC;

  bool get isWithBounsNumber => _isWithBounsNumber;

  String get searchStartValue => _searchStartValue;

  String get searchEndValue => _searchEndValue;

  SearchFilter() {
    setSearchDrawValues();
  }

  setSearchDrawValues() {
    int maxDrawId = AppConstants().getThisWeekDrawId();
    _searchValues =
        List<String>.generate(maxDrawId, (index) => '${index + 1}').toList();
    _searchStartValue = _searchValues.first;
    _searchEndValue = _searchValues.last;
  }

  set dirty(bool value) {
    _dirty = value;
  }

  setSearchType(SearchType searchType) {
    _searchType = searchType;
    if (SearchType.ALL == searchType) {
      _dirty = _dirty ||
          _searchStartValue != _searchValues.first ||
          _searchEndValue != _searchValues.last;

      _searchStartValue = _searchValues.first;
      _searchEndValue = _searchValues.last;
    }
  }

  set searchStartValue(String value) {
    _dirty = _dirty || _searchStartValue != value;
    _searchStartValue = value;
  }

  set searchEndValue(String value) {
    _dirty = _dirty || _searchEndValue != value;
    _searchEndValue = value;
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
