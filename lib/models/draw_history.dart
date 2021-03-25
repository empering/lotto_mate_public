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
        drawCount: map['drawCount'] ?? 0,
        buyAmount: map['buyAmount'] ?? 0,
        buyCount: (map['buyAmount'] ?? 0) ~/ 1000,
        winAmount: map['winAmount'] ?? 0,
        winCount: map['winCount'] ?? 0,
      );

  @override
  String toString() {
    return 'DrawHistory{drawCount: $drawCount, buyAmount: $buyAmount, buyCount: $buyCount, winAmount: $winAmount, winCount: $winCount}';
  }
}
