import 'package:flutter/foundation.dart';
import 'package:lotto_mate/models/buy.dart';
import 'package:lotto_mate/services/buy_service.dart';

class BuyHistoryState with ChangeNotifier {
  final BuyService _buyService = BuyService();
  
  List<Buy>? _buys;

  List<Buy>? get buys => _buys;

  set setBuys(List<Buy> buys) => _buys = buys;

  void getAll() async {
    _buys = await _buyService.getAll();

    notifyListeners();
  }
}
