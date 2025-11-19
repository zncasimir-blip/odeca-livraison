
import 'package:flutter/material.dart';
import '../models/cart.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = CartModel.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Panier')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx,i){
                final it = cart.items[i];
                return ListTile(
                  title: Text(it['name']),
                  subtitle: Text('\${it['qty']} x \${it['price']} FCFA'),
                );
              }
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Text('Total: \${cart.total.toInt()} FCFA', style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
                SizedBox(height:8),
                ElevatedButton(
                  child: Text('Payer'),
                  onPressed: (){
                    Navigator.pushNamed(context, '/checkout');
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
