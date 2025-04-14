import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukk_kantin/models/siswa/cart.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => cart.clearCart(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // Thumbnail image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item.menu.photo,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Item details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.menu.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${item.totalPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Quantity selector moved here and made smaller
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                height: 32,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon:
                                            const Icon(Icons.remove, size: 16),
                                        onPressed: () =>
                                            cart.decrementItem(int.parse(item.menu.id)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 24,
                                      child: Text(
                                        '${item.quantity}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(Icons.add, size: 16),
                                        onPressed: () =>
                                            cart.incrementItem(int.parse(item.menu.id)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Delete button
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red),
                          onPressed: () => cart.removeItem(item),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Total: Rp ${cart.totalPrice.toStringAsFixed(0)}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement checkout functionality
                  },
                  child: const Text('Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
