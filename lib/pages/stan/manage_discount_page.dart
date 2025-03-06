import 'package:flutter/material.dart';

class ManageDiscountPage extends StatelessWidget {
  const ManageDiscountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discount'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Manage Discount Page'),
          ],
        ),
      ),
    );
  }
}
