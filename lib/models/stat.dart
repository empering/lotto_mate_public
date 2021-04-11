import 'package:lotto_mate/models/draw.dart';

class Stat<T> {
  final T statType;
  int count;
  int totCount;

  Stat(this.statType, {this.count = 0, this.totCount = 0});

  get rate => this.count / this.totCount;
}

class SeriesStat {
  final int statType;
  int count;
  Set<Draw> draws = {};

  SeriesStat(this.statType, {this.count = 0});
}
