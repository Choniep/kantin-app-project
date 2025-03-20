import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:ukk_kantin/models/discount.dart';
import 'package:ukk_kantin/pages/stan/add_discount_page.dart';
import 'package:ukk_kantin/services/canteen/diskon_sevice.dart';

class ManageDiscountPage extends StatefulWidget {
  const ManageDiscountPage({super.key});

  @override
  _ManageDiscountPageState createState() => _ManageDiscountPageState();
}

class _ManageDiscountPageState extends State<ManageDiscountPage> {
  final DiskonService _diskonService = DiskonService();
  late Future<List<Diskon>> _discounts;

  @override
  void initState() {
    super.initState();
    // Replace 'userId' with the actual user ID
    _discounts = _diskonService.getUserDiscounts('userId'); // Fetch discounts for the user
  }

  Future<void> _refreshDiscounts() async {
    setState(() {
      _discounts = _discountService.getUserDiscounts('userId'); // Refresh the discounts
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discount'),
        actions: [
          IconButton(
            icon: const Icon(IconsaxPlusBold.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddDiscountPage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Diskon>>(
        future: _discounts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading discounts: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No discounts available'));
          }

          final discounts = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refreshDiscounts,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: discounts.length,
              itemBuilder: (context, index) {
                final discount = discounts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          discount.namaDiskon,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Valid from: ${discount.tanggalMulai} to ${discount.tanggalBerakhir}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Discount: ${discount.diskon} ${discount.diskonType}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
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