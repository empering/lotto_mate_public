class DrawHistory {
  num drawCount;
  num buyAmount;
  num buyCount;
  num winAmount;
  num winCount;

  DrawHistory(
      {this.drawCount = 0,
      this.buyAmount = 0,
      this.buyCount = 0,
      this.winAmount = 0,
      this.winCount = 0});

  factory DrawHistory.fromDb(Map<String, dynamic> map) => DrawHistory(
        drawCount: map['drawCount'],
        buyAmount: map['buyAmount'],
        buyCount: (map['buyAmount'] ?? 0) ~/ 1000,
        winAmount: map['winAmount'],
        winCount: map['winCount'],
      );

  bool get isProfit => winAmount > buyAmount;

  num get profitAmount => winAmount - buyAmount;

  num get profitRate => profitAmount / buyAmount;

  num get winRate => winCount / buyCount;


  @override
  String toString() {
    return 'DrawHistory{drawCount: $drawCount, buyAmount: $buyAmount, buyCount: $buyCount, winAmount: $winAmount, winCount: $winCount}';
  }
}
