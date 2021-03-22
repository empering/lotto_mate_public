class AppConstants {
  final int _baseDrawId = 935;
  final DateTime _baseDrawDate = DateTime.parse('2020-10-31 11:50:00');

  int getThisWeekDrawId() {
    DateTime now = DateTime.now().toLocal();
    int diffDrawId = now.difference(_baseDrawDate).inDays ~/ 7;
    return _baseDrawId + diffDrawId;
  }
}