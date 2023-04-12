library forex_currency_conversion;

import 'package:http/http.dart';
import 'dart:convert';
import '/extensions.dart';

/// A Calculator.
class Forex {
  final String defaultSourceCurrency;
  final String defaultDestinationCurrency;
  final int defaultNumberOfDecimals;
  Map<String, dynamic> _rates = {};
  List<String> _keys = [];

  Forex({
    this.defaultSourceCurrency = 'USD',
    this.defaultDestinationCurrency = 'BRL',
    this.defaultNumberOfDecimals = 2,
  });

  /// function that fetches all avaliable currencies from API.
  Future<String?> _fetchCurrencies() async {
    final Uri baseUri = Uri.parse('http://www.convertmymoney.com/rates.json');
    try {
      final Response response = await get(baseUri);
      final Map<String, dynamic> jsonResponse =
          json.decode(response.body) as Map<String, dynamic>;
      _rates = jsonResponse.remove("rates") as Map<String, dynamic>;
      _keys = _rates.keys.toList();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// checks if the currencies list is empty. If yes, calls _fetchCurrencies().
  Future<String?> _checkCurrenciesList() async {
    if (_rates.isEmpty) {
      return await _fetchCurrencies();
    }
    return null;
  }

  /// resets currencies list.
  Future<String?> updatePrices() async {
    return await _fetchCurrencies();
  }

  /// converts amount from one currency into another using current forex prices.
  Future<double> getCurrencyConverted({
    String? sourceCurrency,
    String? destinationCurrency,
    double sourceAmount = 1,
    int? numberOfDecimals,
  }) async {
    final String? result = await _checkCurrenciesList();
    if (result != null) {
      return 0;
    }
    final String localSourceCurrency = sourceCurrency ?? defaultSourceCurrency;
    final String localDestinationCurrency =
        destinationCurrency ?? defaultDestinationCurrency;
    if (!_keys.contains(localSourceCurrency)) {
      throw Exception(
          "Source Currency provided is invalid. Please Use ISO-4217 currency codes only.");
    }
    if (!_keys.contains(localDestinationCurrency)) {
      throw Exception(
          "Destination Currency provided is invalid. Please Use ISO-4217 currency codes only.");
    }

    final double totalDollarsOfSourceCurrency =
        sourceAmount / _rates[localSourceCurrency];
    return (totalDollarsOfSourceCurrency * _rates[localDestinationCurrency])
        .toPrecision(numberOfDecimals ?? defaultNumberOfDecimals);
  }

  /// returns a Map containing prices of all currencies with their currency_code as key.
  Future<Map<String, double>> getAllCurrenciesPrices({
    int? numberOfDecimals,
  }) async {
    await _checkCurrenciesList();
    final Map<String, double> result = <String, double>{};
    final int decimals = numberOfDecimals ?? defaultNumberOfDecimals;
    for (final element in _keys) {
      result[element] =
          double.parse(_rates[element].toString()).toPrecision(decimals);
    }
    return result;
  }

  /// returns a list of all supported currencies.
  Future<List<String>> getAvailableCurrencies() async {
    await _checkCurrenciesList();
    return _keys;
  }
}
