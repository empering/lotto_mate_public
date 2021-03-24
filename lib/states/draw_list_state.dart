import 'package:flutter/foundation.dart';
import 'package:lotto_mate/models/draw.dart';
import 'package:lotto_mate/services/draw_service.dart';

class DrawListState with ChangeNotifier {
  final DrawService _drawService = DrawService();

  List<Draw> _draws = [];

  List<Draw> get draws => _draws;

  final int limit = 10;
  int offset = 0;
  bool hasMore = false;

  void getDraws() async {
    var draws = await _drawService.getDraws(limit: limit, offset: offset);

    _draws.addAll(draws);

    if (draws.length == limit) {
      hasMore = true;
    } else {
      hasMore = false;
    }

    notifyListeners();
  }
}
