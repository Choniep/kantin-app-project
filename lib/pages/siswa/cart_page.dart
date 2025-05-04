import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukk_kantin/models/siswa/cart_item.dart';
import 'package:ukk_kantin/models/siswa/cart.dart';
import 'package:ukk_kantin/services/Siswa/cart_service.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.items;
    final cartService = CartService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: cart.clear,
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              itemCount: cartItems.length,
              itemBuilder: (context, i) {
                final item = cartItems[i];
                final double? hargaDiskon = item.menu.hargaDiskon;
                final bool isDiscounted = hargaDiskon != null;
                final double effectivePrice =
                    isDiscounted ? hargaDiskon! : item.menu.price;
                // Debug prints
                print('Item: ${item.menu.name}');
                print('Original price: ${item.menu.price}');
                print('Harga Diskon: $hargaDiskon');
                print('Is Discounted: $isDiscounted');
                print('Effective Price: $effectivePrice');

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        if (item.menu.photo.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 64,
                                maxHeight: 64,
                              ),
                              child: Image.network(
                                item.menu.photo,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        else
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.image_not_supported),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                item.menu.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove,
                                              size: 20),
                                          onPressed: () {
                                            cart.updateCartItemQuantity(
                                              item.menu.id,
                                              item.quantity - 1,
                                            );
                                          },
                                        ),
                                        Text('${item.quantity}'),
                                        IconButton(
                                          icon: const Icon(Icons.add, size: 20),
                                          onPressed: () {
                                            cart.updateCartItemQuantity(
                                              item.menu.id,
                                              item.quantity + 1,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (isDiscounted) ...[
                                        Text(
                                          'Rp ${(item.menu.price * item.quantity).toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Rp ${(hargaDiskon! * item.quantity).toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ] else ...[
                                        Text(
                                          'Rp ${(item.menu.price * item.quantity).toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        color: Colors.grey[300],
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Rp ${cartItems.fold<double>(0.0, (sum, item) {
                      final double? hargaDiskon = item.menu.hargaDiskon;
                      final double price = hargaDiskon ?? item.menu.price;
                      return sum + (price * item.quantity);
                    }).toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3CB043),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: cartItems.isEmpty
                      ? null
                      : () async {
                          try {
                            await cartService.checkout(cartItems);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Order placed successfully!')),
                            );
                            cart.clear();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        },
                  child: const Text(
                    'Place Order',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
