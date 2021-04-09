class Stat<T> {
  final T statType;
  int count;
  int totCount;

  Stat(this.statType, {this.count = 0, this.totCount = 0});

  get rate => this.count / this.totCount;
}
