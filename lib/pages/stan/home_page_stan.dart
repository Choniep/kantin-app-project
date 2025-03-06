import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class HomePageStan extends StatelessWidget {
  const HomePageStan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page Stan'),
        ),
        body: SafeArea(
            child: Column(
          children: [
            // header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Stand Performance',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(IconsaxPlusBold.refresh),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),

            // Stats Grid
          ],
        )));
  }
}
