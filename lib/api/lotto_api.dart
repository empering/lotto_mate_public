import 'dart:convert';

import 'package:get/get.dart';
import 'package:lotto_mate/models/draw.dart';

const baseUrl = 'https://www.dhlottery.co.kr/common.do';

class LottoApi extends GetConnect {
  Future<Draw?> fetchLottoNumbers(int id) async {
    final response = await get('$baseUrl?method=getLottoNumber&drwNo=$id');

    if (response.statusCode == 200) {
      if (response.bodyString!.startsWith('<!DOCTYPE html>')) {
        return null;
      } else {
        return Draw.fromJson(json.decode(response.body));
      }
    } else {
      // throw Exception('Fail!');
      return null;
    }
  }
}
