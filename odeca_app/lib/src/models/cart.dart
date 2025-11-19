
import 'package:flutter/material.dart';

class CartModel extends InheritedWidget {
  final List<Map<String,dynamic>> items = [];

  CartModel({required Widget child}): super(child: child);

  static CartModel of(BuildContext context){
    final CartModel? result = context.dependOnInheritedWidgetOfExactType<CartModel>();
    assert(result != null, 'No CartModel found in context');
    return result!;
  }

  void addItem(Map<String,dynamic> item){
    items.add(item);
  }

  double get total {
    double s=0;
    for (var it in items) s += (it['price'] as num) * (it['qty'] as num);
    return s;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
