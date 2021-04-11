import 'package:lotto_mate/models/prize.dart';

class Draw {
  int? id;
  List<int?>? numbers;
  List<Prize>? prizes;

  String? drawDate;
  num? totalSellAmount;
  num? totalFirstPrizeAmount;
  num? eachFirstPrizeAmount;
  int? firstPrizewinnerCount;

  Draw(
      {this.id,
      this.numbers,
      this.prizes,
      this.drawDate,
      this.totalSellAmount,
      this.totalFirstPrizeAmount,
      this.eachFirstPrizeAmount,
      this.firstPrizewinnerCount});

  factory Draw.fromJson(Map<String, dynamic> json) {
    return Draw(
      id: json['drwNo'] as int,
      numbers: [
        json['drwtNo1'] as int,
        json['drwtNo2'] as int,
        json['drwtNo3'] as int,
        json['drwtNo4'] as int,
        json['drwtNo5'] as int,
        json['drwtNo6'] as int,
        json['bnusNo'] as int
      ],
      drawDate: json['drwNoDate'] as String,
      totalSellAmount: json['totSellamnt'] as num,
      totalFirstPrizeAmount: json['firstAccumamnt'] as num,
      eachFirstPrizeAmount: json['firstWinamnt'] as num,
      firstPrizewinnerCount: json['firstPrzwnerCo'] as int,
    );
  }

  Map<String, dynamic> toDb() => {
        'id': id,
        'drawDate': drawDate,
        'totalSellAmount': totalSellAmount,
        'totalFirstPrizeAmount': totalFirstPrizeAmount,
        'eachFirstPrizeAmount': eachFirstPrizeAmount,
        'firstPrizewinnerCount': firstPrizewinnerCount,
        'drawNumber1': numbers![0],
        'drawNumber2': numbers![1],
        'drawNumber3': numbers![2],
        'drawNumber4': numbers![3],
        'drawNumber5': numbers![4],
        'drawNumber6': numbers![5],
        'drawNumberBo': numbers![6],
      };

  factory Draw.fromDb(Map<String, dynamic> map) => Draw(
        id: map['id'],
        drawDate: map['drawDate'],
        totalSellAmount: map['totalSellAmount'],
        totalFirstPrizeAmount: map['totalFirstPrizeAmount'],
        eachFirstPrizeAmount: map['eachFirstPrizeAmount'],
        firstPrizewinnerCount: map['firstPrizewinnerCount'],
        numbers: [
          map['drawNumber1'],
          map['drawNumber2'],
          map['drawNumber3'],
          map['drawNumber4'],
          map['drawNumber5'],
          map['drawNumber6'],
          map['drawNumberBo'],
        ],
      );

  factory Draw.fromFirestore(Map<String, dynamic> map) => Draw(
        id: map['id'],
        drawDate: map['drawDate'],
        totalSellAmount: map['totalSellAmount'],
        totalFirstPrizeAmount: map['totalFirstPrizeAmount'],
        eachFirstPrizeAmount: map['eachFirstPrizeAmount'],
        firstPrizewinnerCount: map['firstPrizewinnerCount'],
        numbers: map['winNumbers'].cast<int>(),
        prizes: (map['rankAmount'] as List).map((e) {
          e['drawId'] = map['id'];
          var prize = Prize.fromFirestore(e);
          return prize;
        }).toList(),
      );

  @override
  String toString() {
    return 'Draw{id: $id, numbers: $numbers, prizes: $prizes, drawDate: $drawDate, totalSellAmount: $totalSellAmount, totalFirstPrizeAmount: $totalFirstPrizeAmount, eachFirstPrizeAmount: $eachFirstPrizeAmount, firstPrizewinnerCount: $firstPrizewinnerCount}';
  }

  String getDrawDateString() {
    var dd = DateTime.parse(this.drawDate!);
    return '${dd.year}년 ${dd.month}월 ${dd.day}일';
  }

  @override
  bool operator ==(Object other) => other is Draw && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
