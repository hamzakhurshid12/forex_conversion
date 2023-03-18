library forex_conversion;

import 'package:http/http.dart' as http;
import 'dart:convert';

/// A Calculator.
class Forex {
  final String defaultSourceCurrency;
  final String defaultDestinationCurrency;
  Map<String, dynamic> _rates = {};
  List<String> _keys = [];

  Forex(
      {this.defaultSourceCurrency = 'USD',
      this.defaultDestinationCurrency = 'BRL'});

  /// function that fetches all avaliable currencies from API.
  Future<void> _fetchCurrencies() async {
    final Uri baseUri = Uri.parse('http://www.convertmymoney.com/rates.json');
    final response = await http.get(baseUri);
    final Map<String, dynamic> jsonResponse =
        json.decode(response.body) as Map<String, dynamic>;
    _rates = jsonResponse.remove("rates") as Map<String, dynamic>;
    _keys = _rates.keys.toList();
  }

  /// checks if the currencies list is empty. If yes, calls _fetchCurrencies().
  Future<void> _checkCurrenciesList() async {
    if (_rates.isEmpty) {
      await _fetchCurrencies();
    }
  }

  /// resets currencies list.
  Future<void> updatePrices() async {
    await _fetchCurrencies();
  }

  /// converts amount from one currency into another using current forex prices.
  Future<double> getCurrencyConverted({
    String? sourceCurrency,
    String? destinationCurrency,
    double sourceAmount = 1,
  }) async {
    await _checkCurrenciesList();
    final String localSourceCurrency = sourceCurrency ?? defaultSourceCurrency;
    final String localDestinationCurrency = destinationCurrency ?? defaultDestinationCurrency;
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
    return totalDollarsOfSourceCurrency * _rates[localDestinationCurrency];
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
