import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'screens/payment_form.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CheckoutApp());
}

class CheckoutApp extends StatelessWidget {
  const CheckoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3E5BFF)),
      useMaterial3: true,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.w700),
        displayLarge: TextStyle(fontWeight: FontWeight.w800),
      ),
    );
    Intl.defaultLocale = 'en_US';
    return MaterialApp(
      title: 'Bank Checkout',
      theme: theme,
      home: const PaymentFormScreen(totalAmount: 2280.0),
      debugShowCheckedModeBanner: false,
    );
  }
}
