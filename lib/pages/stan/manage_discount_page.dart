import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:ukk_kantin/pages/stan/add_discount_page.dart';

class ManageDiscountPage extends StatelessWidget {
  const ManageDiscountPage({super.key});

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
                MaterialPageRoute(builder: (context) => const AddDiscountPage())
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text('Manage Discount Page'),
            ],
          ),
        ),
      ),
    );
  }
}
