class Prize {
  final int? id;
  final int? drawId;
  final int? rank;
  final num? totalAmount;
  final int? winnerCount;
  final num? eachAmount;

  Prize(
      {this.id,
      this.drawId,
      this.rank,
      this.totalAmount,
      this.winnerCount,
      this.eachAmount});

  Map<String, dynamic> toDb() => {
        'id': id,
        'drawId': drawId,
        'rank': rank,
        'totalAmount': totalAmount,
        'winnerCount': winnerCount,
        'eachAmount': eachAmount,
      };

  factory Prize.fromDb(Map<String, dynamic> map) => Prize(
    id: map['id'],
    drawId: map['drawId'],
    rank: map['rank'],
    totalAmount: map['totalAmount'],
    winnerCount: map['winnerCount'],
    eachAmount: map['eachAmount'],
  );

  factory Prize.fromFirestore(Map<String, dynamic> map) => Prize(
    id: map['id'],
    drawId: map['drawId'],
    rank: map['rank'],
    totalAmount: map['totAmount'],
    winnerCount: map['rankCount'],
    eachAmount: map['eachAmount'],
  );

  @override
  String toString() {
    return 'Prize{id: $id, drawId: $drawId, rank: $rank, totalAmount: $totalAmount, winnerCount: $winnerCount, eachAmount: $eachAmount}';
  }

}
