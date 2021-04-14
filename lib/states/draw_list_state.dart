import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lotto_mate/models/draw.dart';
import 'package:lotto_mate/services/draw_service.dart';

enum DrawListType {
  DB,
  LIST,
}

class DrawListState with ChangeNotifier {
  final DrawService _drawService;

  final ScrollController _listViewController = ScrollController();

  ScrollController get listViewController => _listViewController;

  DrawListType _drawListType = DrawListType.DB;

  late Function getData;

  List<Draw> _draws = [];

  List<Draw> get draws => _draws;

  List<Draw> _drawsFromParent = [];

  List<BannerAd> _ads = [];

  final int limit = 10;
  int offset = 0;
  bool hasMore = false;

  DrawListState(this._drawService) {
    getData = getDrawsFromDb;

    this._listViewController.addListener(() async {
      if (this._listViewController.position.pixels ==
              this.listViewController.position.maxScrollExtent &&
          this.hasMore) {
        await Future.delayed(Duration(milliseconds: 500));
        this.offset = draws.length;
        this.getData.call();
      }
    });
  }

  set drawListType(DrawListType drawListType) {
    _drawListType = drawListType;

    switch (_drawListType) {
      case DrawListType.DB:
        getData = getDrawsFromDb;
        break;
      case DrawListType.LIST:
        getData = getDrawsFromList;
        break;
    }
  }

  set drawsFromParent(List<Draw>? drawsFromParent) {
    if (_drawListType == DrawListType.LIST) {
      _drawsFromParent = List.from(drawsFromParent ?? []);
    }
  }

  List<BannerAd> get ads => _ads;

  getDraws({DrawListType? drawListType, List<Draw>? drawsFromParent}) {
    this.drawListType = drawListType ?? _drawListType;
    this.drawsFromParent = drawsFromParent;

    offset = 0;
    _draws = [];
    _ads = [];

    getData.call();
  }

  getDrawsFromDb() async {
    var draws = await _drawService.getDraws(limit: limit, offset: offset);

    _draws.addAll(draws);

    if (draws.length == limit) {
      hasMore = true;
    } else {
      hasMore = false;
    }

    notifyListeners();
  }

  getDrawsFromList() async {
    if (_drawsFromParent.length > 0) {
      _draws.addAll(_drawsFromParent.sublist(
          offset, offset + min(limit, _drawsFromParent.length - offset)));

      hasMore = _draws.length != _drawsFromParent.length;

      await Future.delayed(Duration(milliseconds: 100));
      notifyListeners();
    }
  }
}
