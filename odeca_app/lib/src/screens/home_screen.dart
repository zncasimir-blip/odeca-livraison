
import 'package:flutter/material.dart';
import '../data_menu.dart';
import 'menu_screen.dart';
import 'dish_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  String _weekday() {
    final now = DateTime.now();
    final names = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
    return names[now.weekday - 1];
  }

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
    final today = _weekday();
    final todayMenu = menuByDay[today] ?? [];

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/mockup1.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 200,
                color: Color(0x99C0332A),
              ),
              Positioned(
                left: 12,
                top: 36,
                child: Row(
                  children: [
                    Container(
                      width: 56, height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                      ),
                    ),
                    SizedBox(width:12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('RESTAURANT ODECA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize:18)),
                        Text('le roi du Donkounou', style: TextStyle(color: Colors.white70, fontSize:14)),
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                right: 16, top: 40,
                child: Stack(
                  children: [
                    Icon(Icons.shopping_cart, color: Colors.white, size:36),
                    Positioned(
                      right:0, top:0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Text('0', style: TextStyle(color: Color(0xFFC0332A), fontSize:12)),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                left:12, right:12, bottom: -24,
                child: Container(
                  height:56,
                  padding: EdgeInsets.symmetric(horizontal:16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius:6, offset: Offset(0,2))],
                  ),
                  child: Row(
                    children: [
                      Expanded(child: TextField(
                        decoration: InputDecoration.collapsed(hintText: 'Rechercher un plat...'),
                      )),
                      Container(
                        width:56, height:56,
                        decoration: BoxDecoration(color: Color(0xFFC0332A), borderRadius: BorderRadius.circular(28)),
                        child: Icon(Icons.search, color: Colors.white),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(height:36),
          Container(
            color: Color(0xFFC0332A),
            height:44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ['Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi','Dimanche','Menu du soir'].map((d) =>
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:12, vertical:8),
                  child: Center(child: Text(d, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
              ).toList(),
            ),
          ),
          SizedBox(height:8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal:16, vertical:8),
            child: Row(
              children: [
                Text('Plat du jour', style: TextStyle(fontSize:18, fontWeight: FontWeight.bold)),
                Expanded(child: Container()),
                Container(height:4, width:150, color: Color(0xFFC0332A)),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal:12),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.88,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  for (var d in todayMenu.take(12))
                    GestureDetector(
                      onTap: () {
                        final hasVariants = d.containsKey('variants') || (d.containsKey('prices') && (d['prices'] as List).length>1);
                        if (hasVariants) _openDishModal(context, d);
                        else Navigator.push(context, MaterialPageRoute(builder: (_)=> MenuScreen()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height:120,
                              margin: EdgeInsets.all(6),
                              decoration: BoxDecoration(color: Color(0xFFC0332A), borderRadius: BorderRadius.circular(20)),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal:8),
                              child: Text(d['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize:16)),
                            ),
                            SizedBox(height:6),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal:8),
                              child: d.containsKey('prices') && (d['prices'] as List).length==1 ? Text('${d['prices'][0]} FCFA') : SizedBox.shrink(),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: ElevatedButton(
                                onPressed: (){
                                  if (d.containsKey('prices') && (d['prices'] as List).length==1){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${d['name']} ajouté au panier')));
                                  } else {
                                    _openDishModal(context, d);
                                  }
                                },
                                child: Text('Ajouter au panier'),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
