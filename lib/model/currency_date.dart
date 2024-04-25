class CurrencyData {
  bool success;
  int timestamp;
  String base;
  String date;
  Map<String, double> rates;

  CurrencyData({
    required this.success,
    required this.timestamp,
    required this.base,
    required this.date,
    required this.rates,
  });

  factory CurrencyData.fromJson(Map<String, dynamic> json) => CurrencyData(
    success: json['success'],
    timestamp: json['timestamp'],
    base: json['base'],
    date: json['date'],
    rates: Map.from(json['rates']).map((k, v) => MapEntry<String, double>(k, v.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'timestamp': timestamp,
    'base': base,
    'date': date,
    'rates': Map.from(rates).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}