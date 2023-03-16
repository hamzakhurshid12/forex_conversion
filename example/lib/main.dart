// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:flutter/material.dart';
import 'package:forex_conversion/forex_conversion.dart';

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
    Map<String, double> allPrices = await fx.getAllCurrenciesPrices();
    print("Exchange rate of PKR: ${allPrices['PKR']}");
    print("Exchange rate of EUR: ${allPrices['EUR']}");
    print("Exchange rate of TRY: ${allPrices['TRY']}");

    List<String> availableCurrencies = await fx.getAvailableCurrencies();
    print("The list of all available currencies: $availableCurrencies");

    double myPriceInPKR = await fx.getCurrencyConverted("USD", "PKR", 252.5);
    print("252.5 USD in PKR: $myPriceInPKR");
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
