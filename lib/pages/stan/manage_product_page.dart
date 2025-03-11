import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ManageProductPage extends StatelessWidget {
  const ManageProductPage({Key? key});

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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text('Add Product Page'),
            ],
          ),
        ),
      ),
    );
  }
}
