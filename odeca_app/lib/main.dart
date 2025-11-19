
import 'package:flutter/material.dart';
import 'src/app.dart';
import 'src/models/cart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(CartModel(child: MyApp()));
}
