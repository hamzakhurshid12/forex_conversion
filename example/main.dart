import 'package:forex_conversion/forex_conversion.dart';

Future<void> main(List<String> arguments) async {
  final fx = Forex();
  Map<String, double> allPrices = await fx.getAllCurrenciesPrices();
  // ignore: avoid_print
  print("Exchange rate of PKR: ${allPrices['PKR']}");
  // ignore: avoid_print
  print("Exchange rate of EUR: ${allPrices['EUR']}");
  // ignore: avoid_print
  print("Exchange rate of TRY: ${allPrices['TRY']}");

  List<String> availableCurrencies = await fx.getAvailableCurrencies();
  // ignore: avoid_print
  print("The list of all available currencies: $availableCurrencies");

  double myPriceInPKR = await fx.getCurrencyConverted("USD", "PKR", 252.5);
  // ignore: avoid_print
  print("252.5 USD in PKR: $myPriceInPKR");
}
