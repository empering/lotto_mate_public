class DrawHistory {
  num? drawCount = 0;
  num? buyAmount = 0;
  num? buyCount = 0;
  num? winAmount = 0;
  num? winCount = 0;

  DrawHistory(
      {this.drawCount,
      this.buyAmount,
      this.buyCount,
      this.winAmount,
      this.winCount});

  factory DrawHistory.fromDb(Map<String, dynamic> map) => DrawHistory(
        drawCount: map['drawCount'],
        buyAmount: map['buyAmount'],
        buyCount: map['buyAmount'] ~/ 1000,
        winAmount: map['winAmount'],
        winCount: map['winCount'],
      );

  @override
  String toString() {
    return 'DrawHistory{drawCount: $drawCount, buyAmount: $buyAmount, buyCount: $buyCount, winAmount: $winAmount, winCount: $winCount}';
  }
}
