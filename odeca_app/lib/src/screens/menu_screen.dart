
import 'package:flutter/material.dart';
import '../data_menu.dart';
import 'dish_detail_screen.dart';

class MenuScreen extends StatelessWidget {
  void _openDishModal(BuildContext context, dynamic d) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.98,
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: Scaffold(
            body: DishDetailScreen(dish: d),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final all = [];
    menuByDay.forEach((k,v)=> all.addAll(v));
    final evening = menuByDay['Evening'] ?? [];
    all.addAll(evening);

    return Scaffold(
      appBar: AppBar(title: Text('Menu complet')),
      body: ListView.builder(
        itemCount: all.length,
        itemBuilder: (ctx,i){
          final d = all[i];
          final hasVariants = d.containsKey('variants') || (d.containsKey('prices') && (d['prices'] as List).length>1);
          final priceLabel = d.containsKey('prices') && (d['prices'] as List).length==1 ? '${d['prices'][0]} FCFA' : 'Voir les choix';
          return ListTile(
            leading: Container(width:72, height:72, decoration: BoxDecoration(color: Color(0xFFC0332A), borderRadius: BorderRadius.circular(16))),
            title: Text(d['name'], style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(priceLabel),
            trailing: hasVariants ? TextButton(child: Text('Voir les choix'), onPressed: ()=> _openDishModal(context, d)) :
              ElevatedButton(child: Text('Ajouter'), onPressed: (){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${d['name']} ajouté au panier')));
              }),
            onTap: ()=> _openDishModal(context, d),
          );
        },
      ),
    );
  }
}
