import 'package:flutter/material.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
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
