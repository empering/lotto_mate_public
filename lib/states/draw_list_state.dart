import 'package:flutter/foundation.dart';
import 'package:lotto_mate/models/draw.dart';
import 'package:lotto_mate/services/draw_service.dart';

class DrawListState with ChangeNotifier {
  final DrawService _drawService = DrawService();

  List<Draw> _draws = [];

  List<Draw> get draws => _draws;

  void getDraws() async {
    _draws = await _drawService.getDraws();

    notifyListeners();
  }
}
