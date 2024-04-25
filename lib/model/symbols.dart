class CurrencySymbols {
  bool success;
  Map<String, String> symbols;

  CurrencySymbols({
    required this.success,
    required this.symbols,
  });

  factory CurrencySymbols.fromJson(Map<String, dynamic> json) => CurrencySymbols(
    success: json['success'],
    symbols: Map<String, String>.from(json['symbols']),
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'symbols': Map.from(symbols).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}