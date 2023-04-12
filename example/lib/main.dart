// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:flutter/material.dart';
import 'package:forex_currency_conversion/forex_currency_conversion.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loading = false;
  final fx = Forex();

  Future<void> testCurrency() async {
    loadingState();
    final Map<String, double> allPrices = await fx.getAllCurrenciesPrices();
    print("Exchange rate of PKR: ${allPrices['PKR']}");
    print("Exchange rate of EUR: ${allPrices['EUR']}");
    print("Exchange rate of TRY: ${allPrices['TRY']}");

    final List<String> availableCurrencies = await fx.getAvailableCurrencies();
    print("The list of all available currencies: $availableCurrencies");

    final double myPriceInPKR = await fx.getCurrencyConverted(
        sourceCurrency: "USD", destinationCurrency: "PKR", sourceAmount: 252.5);
    print("252.5 USD in PKR: $myPriceInPKR");
    print(
        "Default exchange rate (USD - BRL): ${await fx.getCurrencyConverted()}");
    loadingState();
  }

  void loadingState() {
    setState(() {
      _loading = !_loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
              .copyWith(secondary: Colors.pinkAccent)),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Forex Conversion Example App'),
        ),
        body: Center(
          child: _loading
              ? const CircularProgressIndicator()
              : TextButton(
                  onPressed: testCurrency,
                  child: const Text(
                    'Try it',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
        ),
      ),
    );
  }
}
