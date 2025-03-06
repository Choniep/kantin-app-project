import 'package:flutter/material.dart';
import 'package:ukk_kantin/models/restaurant.dart';
import 'detail_menu_page.dart'; // new import

class MenuPage extends StatelessWidget {
  final Restaurant restaurant;

  const MenuPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
      body: ListView.builder(
        itemCount: restaurant.menus.length,
        itemBuilder: (context, index) {
          final menu = restaurant.menus[index];
          return ListTile(
            title: Text(menu.name),
            subtitle: Text(menu.description ?? ''),
            trailing: Text('\$${menu.price.toStringAsFixed(2)}'),
            onTap: () {
              // added onTap navigation
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailMenuPage(menu: menu),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
