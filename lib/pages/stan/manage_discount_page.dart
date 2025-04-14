import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:ukk_kantin/models/discount.dart'; // Ensure this is the correct import
import 'package:ukk_kantin/pages/stan/add_discount_page.dart';
import 'package:ukk_kantin/services/canteen/diskon_sevice.dart';

class ManageDiscountPage extends StatefulWidget {
  const ManageDiscountPage({super.key});

  @override
  _ManageDiscountPageState createState() => _ManageDiscountPageState();
}

class _ManageDiscountPageState extends State<ManageDiscountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DiskonService _diskonService = DiskonService();
  late Future<List<Diskon>> _discounts;

  @override
  void initState() {
    super.initState();
    _refreshDiscounts(); // Load discounts when the page is initialized
  }

  Future<void> _refreshDiscounts() async {

    // Fetch the discounts for the user
    _discounts = _diskonService.getUserDiscounts();

    // Wait for the Future to complete and check if the discounts are empty
    List<Diskon> discountsList = await _discounts;
    if (discountsList.isEmpty) {
      print('No discounts found');
    } else {
      print(
          'Discounts retrieved successfully: ${discountsList.length} discounts found.');
    }
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
                MaterialPageRoute(
                    builder: (context) => const AddDiscountPage()),
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
            return Center(
                child: Text('Error loading discounts: ${snapshot.error}'));
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
                          discount
                              .namaDiskon, // Ensure this field exists in your Diskon model
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Valid from: ${discount.tanggalMulai} to ${discount.tanggalBerakhir}', // Ensure these fields exist
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Discount: ${discount.diskon} ${discount.diskonType}', // Ensure these fields exist
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
