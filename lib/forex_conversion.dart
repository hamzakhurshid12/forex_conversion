library forex_conversion;

import 'package:http/http.dart' as http;
import 'dart:convert';

/// A Calculator.
class Forex {
  Map<String, dynamic> _rates = {};
  List<String> _keys = [];

  Future<void> _checkCurrenciesList() async {
    if (_rates.isEmpty) {
      await _fetchCurrencies();
    }
  }

  Future<void> _fetchCurrencies() async {
    final Uri baseUri = Uri.parse('http://www.convertmymoney.com/rates.json');
    final response = await http.get(baseUri);
    final Map<String, dynamic> jsonResponse =
        json.decode(response.body) as Map<String, dynamic>;
    _rates = jsonResponse.remove("rates") as Map<String, dynamic>;
    _keys = _rates.keys.toList();
  }

  /// converts amount from one currency into another using current forex prices.
  Future<double> getCurrencyConverted({
    String sourceCurrency = 'USD',
    String destinationCurrency = 'BRL',
    double sourceAmount = 1,
  }) async {
    await _checkCurrenciesList();
    if (!_keys.contains(sourceCurrency)) {
      throw Exception(
          "Source Currency provided is invalid. Please Use ISO-4217 currency codes only.");
    }
    if (!_keys.contains(destinationCurrency)) {
      throw Exception(
          "Destination Currency provided is invalid. Please Use ISO-4217 currency codes only.");
    }

    final double totalDollarsOfSourceCurrency =
        sourceAmount / _rates[sourceCurrency];
    return totalDollarsOfSourceCurrency * _rates[destinationCurrency];
  }

  /// returns a Map containing prices of all currencies with their currency_code as key.
  Future<Map<String, double>> getAllCurrenciesPrices() async {
    await _checkCurrenciesList();
    final Map<String, double> result = <String, double>{};
    for (final element in _keys) {
      result[element] = double.parse(_rates[element].toString());
    }
    return result;
  }

  /// returns a list of all supported currencies.
  Future<List<String>> getAvailableCurrencies() async {
    await _checkCurrenciesList();
    return _keys;
  }
}
