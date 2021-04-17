class AppConstants {
  final int _baseDrawId = 958;
  final DateTime _baseDrawDate = DateTime.parse('2021-04-10 20:50:00');

  int getThisWeekDrawId() {
    DateTime now = DateTime.now().toLocal();
    int diffDrawId = now.difference(_baseDrawDate).inDays ~/ 7;
    return _baseDrawId + diffDrawId;
  }
}
