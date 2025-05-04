import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:ukk_kantin/models/discount.dart';
import 'package:ukk_kantin/services/canteen/diskon_service.dart';
import 'package:ukk_kantin/services/canteen/menu_service.dart';
import 'package:ukk_kantin/models/stan/create_menu.dart';
import 'package:ukk_kantin/pages/stan/edit_product_page.dart';

class ManageProductPage extends StatefulWidget {
  const ManageProductPage({super.key});

  @override
  _ManageProductPageState createState() => _ManageProductPageState();
}

class _ManageProductPageState extends State<ManageProductPage> {
  final DiskonService _diskonService = DiskonService();
  final MenuService _menuService = MenuService();
  late Future<List<CreateMenu>> _menus;

  @override
  void initState() {
    super.initState();
    _menus = fetchMenus(); // Fetch menus when the widget is initialized
  }

  Future<void> _refreshMenus() async {
    setState(() {
      _menus = fetchMenus(); // Refresh the menus
    });
  }

  Future<List<CreateMenu>> fetchMenus() async {
    // Fetch your menus from the service
    List<CreateMenu> menus = await _menuService.getCurrentUserMenus();

    // Fetch discounts for each menu and check if they are active
    for (var menu in menus) {
      List<Diskon> diskons = await _diskonService.getDiskonsForMenu(menu.id!);
      _diskonService.checkDiskon(
          menu, diskons); // Check discounts for each menu
    }

    return menus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/add_product');
            },
            icon: const Icon(IconsaxPlusBold.add),
          ),
        ],
      ),
      body: FutureBuilder<List<CreateMenu>>(
        future: _menus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Print the error to the console
            print('Error loading menus: ${snapshot.error}');
            return Center(
                child: Text('Error loading menus: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No menus available'));
          }

          final menus = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refreshMenus,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: menus.length,
              itemBuilder: (context, index) {
                final menu = menus[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Menu Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: menu.foto != null
                              ? Image.network(
                                  menu.foto!,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    width: 70,
                                    height: 70,
                                    color: Colors.grey[200],
                                    child: Icon(Icons.fastfood,
                                        color: Colors.grey[400], size: 30),
                                  ),
                                )
                              : Container(
                                  width: 70,
                                  height: 70,
                                  color: Colors.grey[200],
                                  child: Icon(Icons.fastfood,
                                      color: Colors.grey[400], size: 30),
                                ),
                        ),
                        const SizedBox(width: 16),
                        // Menu Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                menu.nama,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Display original price crossed out if there's a discount
                              if (menu.isDiskon)
                                Text(
                                  'Rp ${menu.harga.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration
                                        .lineThrough, // Strikethrough effect
                                  ),
                                ),
                              // Display discounted price
                              Text(
                                'Rp ${menu.harga.toStringAsFixed(0)}', // Show discounted price
                                style: TextStyle(
                                  fontSize: 14,
                                  color: menu.isDiskon
                                      ? Colors.red
                                      : Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: menu.jenis == JenisMenu.makanan
                                      ? Colors.orange[50]
                                      : Colors.blue[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  menu.jenis == JenisMenu.makanan
                                      ? 'Makanan'
                                      : 'Minuman',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: menu.jenis == JenisMenu.makanan
                                        ? Colors.orange[800]
                                        : Colors.blue[800],
                                  ),
                                ),
                              ),
                              if (menu
                                  .isDiskon) // Show a label if there's a discount
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'DISKON',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Menu Actions
                        IconButton(
                          icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Wrap(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.edit),
                                    title: const Text('Edit'),
                                    onTap: () {
                                      Navigator.pop(
                                          context); // Close the bottom sheet
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditProductPage(menu: menu),
                                        ),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.delete),
                                    title: const Text('Delete'),
                                    onTap: () async {
                                      Navigator.pop(
                                          context); // Close the bottom sheet
                                      bool success = await _menuService
                                          .deleteMenu(menu.id!);
                                      if (success) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Menu deleted successfully')),
                                        );
                                        _refreshMenus();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Failed to delete menu')),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
