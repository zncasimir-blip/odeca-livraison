
import 'package:flutter/material.dart';

class DishDetailScreen extends StatelessWidget {
  final dynamic dish;
  DishDetailScreen({required this.dish});

  @override
  Widget build(BuildContext context) {
    final variants = dish['variants'] ?? [];
    final prices = dish['prices'] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(dish['name'])),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Image.asset(dish['image'] ?? 'assets/images/mockup1.png', height:200, fit: BoxFit.cover),
              SizedBox(height:12),
              if (variants.isNotEmpty) ...variants.map<Widget>((v){
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(width:100, height:100, decoration: BoxDecoration(color: Color(0xFFC0332A), borderRadius: BorderRadius.circular(16))),
                        SizedBox(width:12),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(v['name'], style: TextStyle(fontSize:18, fontWeight: FontWeight.bold)),
                            SizedBox(height:6),
                            Text((v['prices'] as List).join(' / ') + ' FCFA'),
                            SizedBox(height:8),
                            ElevatedButton(child: Text('Ajouter au panier'), onPressed: (){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('\${v['name']} ajouté au panier')));
                            })
                          ],
                        ))
                      ],
                    ),
                  ),
                );
              }).toList() else if (prices.isNotEmpty && (prices as List).length>1) ...[
                for (var p in prices) Card(
                  elevation:0,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(width:100, height:100, decoration: BoxDecoration(color: Color(0xFFC0332A), borderRadius: BorderRadius.circular(16))),
                        SizedBox(width:12),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(dish['name'], style: TextStyle(fontSize:18, fontWeight: FontWeight.bold)),
                            SizedBox(height:6),
                            Text('\$p FCFA'),
                            SizedBox(height:8),
                            ElevatedButton(child: Text('Ajouter au panier'), onPressed: (){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('\${dish['name']} ajouté au panier - \$p FCFA')));
                            })
                          ],
                        ))
                      ],
                    ),
                  ),
                )
              ] else ...[
                Card(
                  elevation:0,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Container(height:140, decoration: BoxDecoration(color: Color(0xFFC0332A), borderRadius: BorderRadius.circular(12))),
                        SizedBox(height:12),
                        Text(dish['name'], style: TextStyle(fontSize:20, fontWeight: FontWeight.bold)),
                        SizedBox(height:8),
                        if (prices.isNotEmpty) Text('\${prices[0]} FCFA', style: TextStyle(fontSize:16)),
                        SizedBox(height:12),
                        ElevatedButton(child: Text('Ajouter au panier'), onPressed: (){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('\${dish['name']} ajouté au panier')));
                        })
                      ],
                    ),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
