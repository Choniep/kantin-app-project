import 'package:flutter/material.dart';
import 'package:ukk_kantin/models/menu.dart';

class DetailMenuPage extends StatelessWidget {
  final Menu menu;

  const DetailMenuPage({Key? key, required this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(menu.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menu picture
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                menu.photo, // Change to Image.asset if using local assets
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            // Menu name
            Text(
              menu.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Menu description
            Text(
              menu.description ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            // Menu price
            Text(
              '\$${menu.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
