import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lotto_mate/main.dart';

void main() async {
  var buildNumer = await mainCommon();

  runApp(MyApp(
    isReleases: kReleaseMode,
    buildNumer: buildNumer,
    storeType: StoreType.ONE_STORE,
  ));
}
