import 'package:flutter/material.dart';
import 'package:ukk_kantin/models/restaurant.dart';
import 'menu_page.dart';

class HomePageSiswa extends StatelessWidget {
  const HomePageSiswa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page Siswa'),
      ),
      body: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(restaurants[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MenuPage(restaurant: restaurants[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
