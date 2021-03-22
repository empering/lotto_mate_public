class PickResult {
  int? id;
  int? pickId;
  int rank;
  num amount;

  PickResult({this.id, this.pickId, this.rank = 0, this.amount = 0});

  Map<String, dynamic> toDb() => {
        'id': id,
        'pickId': pickId,
        'rank': rank,
        'amount': amount,
      };

  factory PickResult.fromDb(Map<String, dynamic> map) => PickResult(
    id: map['id'],
    pickId: map['pickId'],
    rank: map['rank'],
    amount: map['amount'],
  );

}
