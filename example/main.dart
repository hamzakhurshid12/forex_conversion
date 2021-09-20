import 'package:forex_conversion/forex_conversion.dart';

Future<void> main(List<String> arguments) async {

  final fx = Forex();
  Map<String, double> allPrices = await fx.getAllCurrenciesPrices();
  print("Exchange rate of PKR: ${allPrices['PKR']}");
  print("Exchange rate of EUR: ${allPrices['EUR']}");
  print("Exchange rate of TRY: ${allPrices['TRY']}");

  List<String> availableCurrencies = await fx.getAvailableCurrencies();
  print("The list of all available currencies: ${availableCurrencies}");

  double myPriceInPKR = await fx.getCurrencyConverted("USD", "PKR", 252.5);
  print("252.5 USD in PKR: ${myPriceInPKR}");

}