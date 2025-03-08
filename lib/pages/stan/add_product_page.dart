import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/stan/product_list');
            },
            icon: const Icon(IconsaxPlusBold.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Add Product Page'),
          ],
        ),
      ),
    );
  }
}
