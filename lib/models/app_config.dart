class AppConfig {
  String configId;
  String? configValue;
  String? configDate;

  AppConfig({
    required this.configId,
    this.configValue,
    this.configDate,
  });

  factory AppConfig.fromDb(Map<String, dynamic> map) => AppConfig(
        configId: map['configId'],
        configValue: map['configValue'],
        configDate: map['configDate'],
      );

  Map<String, dynamic> toDb() => {
        'configId': configId,
        'configValue': configValue,
        'configDate': DateTime.now().toIso8601String(),
      };
}
