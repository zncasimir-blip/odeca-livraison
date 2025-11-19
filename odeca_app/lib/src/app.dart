
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'theme.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ODECA',
      theme: OdecaTheme.light(),
      initialRoute: '/',
      routes: {
        '/': (_) => HomeScreen(),
        '/menu': (_) => MenuScreen(),
        '/cart': (_) => CartScreen(),
        '/checkout': (_) => CheckoutScreen(),
      },
    );
  }
}
