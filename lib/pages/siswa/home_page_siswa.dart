import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:ukk_kantin/models/menu.dart';
import 'package:ukk_kantin/models/siswa/restaurant.dart'; // Ensure this is the correct import
import 'menu_page.dart';

class HomePageSiswa extends StatelessWidget {
  const HomePageSiswa({super.key});

  Future<List<Restaurant>> _fetchRestaurants() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('stan').get();
    return Future.wait(snapshot.docs.map((doc) async {
      final data = doc.data() as Map<String, dynamic>;
      final menus = await _fetchMenus(doc.id);
      return Restaurant(
        id: doc.id,
        name: data['nama_stan'] ?? 'Unknown Restaurant',
        menus: menus,
      );
    }));
  }

  Future<List<Menu>> _fetchMenus(String restaurantId) async {
    final QuerySnapshot menuSnapshot = await FirebaseFirestore.instance
        .collection('stan')
        .doc(restaurantId)
        .collection('menu')
        .get();
    return menuSnapshot.docs
        .map((menuDoc) =>
            Menu.fromMap(menuDoc.data() as Map<String, dynamic>, menuDoc.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kantin Sekolah',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Pesan makanan favoritmu!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),  
      ),
      body: FutureBuilder<List<Restaurant>>(
        future: _fetchRestaurants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error loading restaurants: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No restaurants available'));
          }

          final restaurants = snapshot.data!;
          return ListView(
            children: [
              // Categories Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kategori',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildCategoryItem('Makanan', Icons.restaurant),
                          _buildCategoryItem('Minuman', Icons.local_drink),
                          _buildCategoryItem('Snack', Icons.cookie),
                          _buildCategoryItem('Promo', Icons.discount),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Restaurants Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Stan Tersedia',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: restaurants.length,
                      itemBuilder: (context, index) {
                        return _buildRestaurantCard(
                            context, restaurants[index]);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 30,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantCard(BuildContext context, Restaurant restaurant) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuPage(restaurant: restaurant),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                'https://picsum.photos/seed/${restaurant.id}/400/200', // Placeholder image
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Name
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Rating and Categories
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const Text(
                        '4.5',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${restaurant.menus.length} Menu',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Additional Info
                  const Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        'Buka',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
