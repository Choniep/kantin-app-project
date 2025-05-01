import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:ukk_kantin/models/siswa/restaurant.dart';
import 'detail_menu_page.dart';

class MenuPage extends StatelessWidget {
  final Restaurant restaurant;

  const MenuPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: restaurant.menus.length,
        itemBuilder: (context, index) {
          final menu = restaurant.menus[index];

          // Calculate the discounted price if applicable
          double? discountedPrice;
          if (menu.isDiskon &&
              menu.diskon != null &&
              menu.jenisDiskon != null) {
            discountedPrice = menu.jenisDiskon == 'persen'
                ? menu.price * (1 - (menu.diskon! / 100))
                : menu.price - (menu.diskon!);
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailMenuPage(menu: menu),
                    ),
                  );
                },
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      child: (menu.photo != null && menu.photo.isNotEmpty)
                          ? Image.asset(
                              menu.photo,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.restaurant,
                                      color: Colors.grey),
                                );
                              },
                            )
                          : Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[300],
                              child: const Icon(Icons.restaurant,
                                  color: Colors.grey),
                            ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              menu.name ?? 'Unknown',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              menu.description ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8), // Add some space
                            // Price display
                            if (menu.isDiskon) ...[
                              // Show original price with strikethrough
                              Text(
                                'Rp. ${menu.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(height: 4), // Space between prices
                              // Show discounted price
                              Text(
                                'Rp. ${discountedPrice?.toStringAsFixed(2) ?? '0.00'}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ] else ...[
                              Text('Rp. ${discountedPrice?.toStringAsFixed(2) ?? '0.00'}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
