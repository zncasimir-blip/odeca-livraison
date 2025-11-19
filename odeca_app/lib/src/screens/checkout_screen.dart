
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import '../models/cart.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  String selectedNetwork = 'OrangeMoney';
  String locationLink = '';
  bool sending = false;

  Map<String,String> agentCodes = {
    'OrangeMoney': '*144*3*4248859*{amount}#',
    'MoovMoney': '*123*1*000000*{amount}#',
    'TelecelMoney': '*789*2*111111*{amount}#',
  };

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Active la localisation sur ton téléphone')));
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Permission de localisation refusée')));
        return;
      }
    }
    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      locationLink = 'https://www.google.com/maps/search/?api=1&query=\${pos.latitude},\${pos.longitude}';
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Localisation prise')));
  }

  Future<void> _submitOrder() async {
    final cart = CartModel.of(context);
    final amount = cart.total.toInt();
    if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Remplis ton nom et adresse mail')));
      return;
    }
    if (locationLink.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ajoute ta localisation')));
      return;
    }

    setState(()=> sending = true);
    final payload = {
      'name': _nameCtrl.text,
      'email': _emailCtrl.text,
      'amount': amount,
      'network': selectedNetwork,
      'location': locationLink,
      'items': CartModel.of(context).items,
    };

    try {
      final res = await http.post(Uri.parse('http://10.0.2.2:3000/send-order'),
        headers: {'Content-Type':'application/json'},
        body: jsonEncode(payload),
      );
      if (res.statusCode == 200) {
        final template = agentCodes[selectedNetwork] ?? agentCodes['OrangeMoney']!;
        final ussd = template.replaceAll('{amount}', amount.toString());
        final encoded = ussd.replaceAll('#','%23');
        final uri = Uri.parse('tel:$encoded');
        if (Theme.of(context).platform == TargetPlatform.android) {
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Impossible de lancer l\'appel USSD')));
          }
        } else {
          await Clipboard.setData(ClipboardData(text: ussd));
          showDialog(context: context, builder: (_)=> AlertDialog(
            title: Text('Code USSD copié'),
            content: Text('Le code USSD a été copié dans le presse-papier. Ouvre l\'app Téléphone et colle-le pour payer.'),
            actions: [TextButton(child: Text('OK'), onPressed: ()=> Navigator.pop(context))],
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'envoi, la requête USSD ne sera pas lancée')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur réseau: \$e')));
    } finally {
      setState(()=> sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartModel.of(context);
    final amount = cart.total.toInt();
    return Scaffold(
      appBar: AppBar(title: Text('Paiement')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(controller: _nameCtrl, decoration: InputDecoration(labelText: 'Nom et prénom')),
            TextField(controller: _emailCtrl, decoration: InputDecoration(labelText: 'Adresse mail')),
            SizedBox(height:8),
            Row(children: [
              Text('Montant: ', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('\$amount FCFA', style: TextStyle(fontSize:16)),
            ]),
            SizedBox(height:8),
            DropdownButton<String>(
              value: selectedNetwork,
              items: ['OrangeMoney','MoovMoney','TelecelMoney'].map((s)=> DropdownMenuItem(child: Text(s), value: s)).toList(),
              onChanged: (v)=> setState(()=> selectedNetwork = v!),
            ),
            SizedBox(height:8),
            Row(
              children: [
                ElevatedButton.icon(onPressed: _getLocation, icon: Icon(Icons.location_on), label: Text('Envoyer localisation')),
                SizedBox(width:8),
                if (locationLink.isNotEmpty) Expanded(child: SelectableText(locationLink)),
              ],
            ),
            Spacer(),
            ElevatedButton(
              child: sending ? CircularProgressIndicator(color: Colors.white) : Text('Valider le paiement'),
              onPressed: sending ? null : _submitOrder,
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity,48)),
            )
          ],
        ),
      ),
    );
  }
}
