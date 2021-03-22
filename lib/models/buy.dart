import 'package:cloud_firestore/cloud_firestore.dart';

class Buy {
  int? id;
  int? drawId;
  List<Pick>? picks;
  DocumentReference? draw;

  Buy({this.id, this.drawId, this.picks, this.draw});

  Map<String, dynamic> toJson() => {
        'id': id,
        'drawId': drawId,
        'picks': picks!.map((e) => e.toJson()).toList()
      };

  Map<String, dynamic> toDb() => {
        'id': id,
        'drawId': drawId,
      };

  factory Buy.fromFirestore(Map<String, dynamic> json) => Buy(
        id: json['id'],
        drawId: json['drawId'],
        picks: (json['picks'] as List).map((e) => Pick.fromDb(e)).toList(),
      );

  factory Buy.fromDb(Map<String, dynamic> map) => Buy(
        id: map['id'],
        drawId: map['drawId'],
      );

  factory Buy.fromQr(String qrData) {
    return Buy(
        drawId: int.parse(qrData.substring(0, 4)), picks: _parsePicks(qrData));
  }

  static List<Pick> _parsePicks(String queryString) {
    List<Pick> picks = [];
    int index = 4;

    while (index < 69) {
      String gameType = _getGameType(queryString, index++);
      if (gameType != 'q' && gameType != 'm') {
        break;
      } else {
        picks.add(
            Pick(type: gameType, numbers: _getGameNumbers(queryString, index)));
        index += 12;
      }
    }

    return picks;
  }

  static String _getGameType(String queryString, int index) {
    return queryString.substring(index, index + 1);
  }

  static List<int> _getGameNumbers(String queryString, int index) {
    List<int> result = [];
    int nextIndex = index + 2;

    for (var i = 1; i <= 6; i++) {
      result.add(int.parse(queryString.substring(index, nextIndex)));

      index = nextIndex;
      nextIndex += 2;
    }

    return result;
  }
}

class Pick {
  int? id;
  int? buyId;
  String? type; // m: 수동, q: 자동
  List<int?>? numbers;
  bool? isPicked;
  late PickResult? pickResult;

  Pick({this.id, this.type, this.numbers, this.isPicked = false});

  Pick.generate({this.type, this.isPicked}) {
    this.type = this.type ?? 'q';
    this.numbers = List.filled(6, null, growable: false);
    this.isPicked = this.isPicked ?? false;
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'numbers': numbers,
      };

  Map<String, dynamic> toDb() => {
        'buyId': buyId,
        'type': type,
        'pickNumber1': numbers![0],
        'pickNumber2': numbers![1],
        'pickNumber3': numbers![2],
        'pickNumber4': numbers![3],
        'pickNumber5': numbers![4],
        'pickNumber6': numbers![5]
      };

  factory Pick.fromDb(Map<String, dynamic> json) => Pick(
        id: json['id'],
        type: json['type'],
        numbers: [
          json['pickNumber1'],
          json['pickNumber2'],
          json['pickNumber3'],
          json['pickNumber4'],
          json['pickNumber5'],
          json['pickNumber6'],
        ],
      );
}

class PickResult {
  int? pickId;
  int? rank;
  String rankName = '낙첨';
  num? amount;

  PickResult({this.pickId, this.rank, this.rankName = '낙첨', this.amount = 0});

  factory PickResult.fromDb(Map<String, dynamic> map) => PickResult(
        pickId: map['pickId'],
        rank: map['rank'],
        rankName: map['rank'] > 0 ? '${map['rank']}등' : '낙첨',
        amount: map['amount'],
      );

  Map<String, dynamic> toDb() => {
        'pickId': pickId,
        'rank': rank,
        'amount': amount,
      };
}
