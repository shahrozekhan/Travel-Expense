
class ExchangeRate {
  final String currency;
  final String currencyName;
  final double rate;

  ExchangeRate({
    required this.currency,
    required this.currencyName,
    required this.rate,
  });
}

List<ExchangeRate> getExchangeRateSortedOnCurrencies(Map<String, double>? rates,
    Map<String, String>? symbols,) {
  List<ExchangeRate> exchangeRateDtoList = [];

  rates?.forEach((currency, rate) {
    String? currencyName = symbols?[currency];
    if (currencyName != null) {
      exchangeRateDtoList.add(
        ExchangeRate(
            currency: currency, currencyName: currencyName, rate: rate),
      );
    }
  });

  return exchangeRateDtoList;
}
