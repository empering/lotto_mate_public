class AppConstants {
  final int _baseDrawId = 958;
  final DateTime _baseDrawDate = DateTime.parse('2021-04-10 20:50:00');

  int getThisWeekDrawId() {
    DateTime now = DateTime.now().toLocal();
    int diffDrawId = now.difference(_baseDrawDate).inDays ~/ 7;
    return _baseDrawId + diffDrawId;
  }

  DateTime getNextDrawDateTime() {
    DateTime now = DateTime.now().toLocal();
    int diffDrawId = now.difference(_baseDrawDate).inDays ~/ 7;

    DateTime thisWeekDrawDate = DateTime(
      _baseDrawDate.year,
      _baseDrawDate.month,
      _baseDrawDate.day,
      21,
      0,
    );
    thisWeekDrawDate =
        thisWeekDrawDate.add(Duration(days: (diffDrawId + 1) * 7));

    return thisWeekDrawDate;
  }
}
