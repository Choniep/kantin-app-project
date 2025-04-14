import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:ukk_kantin/models/discount.dart'; // Ensure this is the correct import
import 'package:ukk_kantin/pages/stan/add_discount_page.dart';
import 'package:ukk_kantin/services/canteen/diskon_service.dart';
import 'package:intl/intl.dart'; // For date formatting

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
    _discounts = _diskonService.getUserDiscounts();
  }

  Future<void> _refreshDiscounts() async {
    setState(() {
      _discounts = _diskonService.getUserDiscounts();
    });

    try {
      final discountsList = await _discounts;
      if (discountsList.isEmpty) {
        print('No discounts found');
      } else {
        print(
            'Discounts retrieved successfully: ${discountsList.length} discounts found.');
      }
    } catch (e) {
      print('Error fetching discounts: $e');
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  Future<void> _deleteDiscount(Diskon discount) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Discount'),
        content: const Text('Are you sure you want to delete this discount?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _diskonService.deleteDiscount(discount.menuId!, discount.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Discount deleted successfully')),
        );
        await _refreshDiscounts();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete discount: $e')),
        );
      }
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                discount.namaDiskon,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteDiscount(discount),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Menu: ${discount.menuName ?? 'No Menu Name'}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Valid from: ${_formatDate(discount.tanggalMulai)} to ${_formatDate(discount.tanggalBerakhir)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          discount.diskonType == 'persen'
                              ? 'Discount: ${discount.diskon}%'
                              : discount.diskonType == 'rupiah'
                                  ? 'Discount: Rp. ${discount.diskon}'
                                  : 'Discount: ${discount.diskon}',
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