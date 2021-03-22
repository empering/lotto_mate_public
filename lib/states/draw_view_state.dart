import 'package:flutter/foundation.dart';
import 'package:lotto_mate/models/draw.dart';
import 'package:lotto_mate/services/draw_service.dart';

class DrawViewState extends ChangeNotifier {
  final DrawService _drawService = DrawService();

  final int _drawId;
  bool loading = true;

  DrawViewState(this._drawId);

  Draw? _draw;

  Draw? get draw => _draw;

  getDraw() async {
    _draw = await _drawService.getDrawById(_drawId);

    notifyListeners();
  }
}
