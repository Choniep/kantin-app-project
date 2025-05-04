import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukk_kantin/models/menu.dart';
import 'package:ukk_kantin/models/siswa/cart_item.dart';
import 'package:ukk_kantin/models/siswa/cart.dart';

class DetailMenuPage extends StatefulWidget {
  final Menu menu;
  final double? hargaDiskon; // Add the hargaDiskon parameter
  const DetailMenuPage({super.key, required this.menu, this.hargaDiskon});

  @override
  _DetailMenuPageState createState() => _DetailMenuPageState();
}

class _DetailMenuPageState extends State<DetailMenuPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final menuId = widget.menu.id.toString();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.menu.photo),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.menu.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        // Display the original price with a strike-through if discount exists
                        widget.hargaDiskon != null &&
                                widget.hargaDiskon != widget.menu.price
                            ? Text(
                                'Rp ${widget.menu.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 8),
                        // Display the discounted price (if applicable)
                        Text(
                          'Rp ${widget.hargaDiskon?.toStringAsFixed(0) ?? widget.menu.price.toStringAsFixed(0)}',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Description',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.menu.description ?? 'No description available',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),
                        Text('Quantity'),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (_quantity > 1) _quantity--;
                                });
                              },
                            ),
                            Text('$_quantity'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  _quantity++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                // Calculate discounted price (if applicable)
                double discountedPrice =
                    widget.hargaDiskon ?? widget.menu.price;

                final discountedMenu = Menu(
                  id: menuId,
                  name: widget.menu.name,
                  description: widget.menu.description,
                  price: discountedPrice,
                  photo: widget.menu.photo,
                  stanId: widget.menu.stanId,
                  isDiskon: widget.menu.isDiskon,
                  jenisMenu: widget.menu.jenisMenu,
                  diskon: widget.menu.diskon ?? 0,
                  jenisDiskon: widget.menu.jenisDiskon,
                );

                final result =
                    Provider.of<Cart>(context, listen: false).addItem(
                  CartItem(menu: discountedMenu, quantity: _quantity),
                );

                if (result) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Added to cart'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'You can only order from one stan at a time.',
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart),
                  SizedBox(width: 8),
                  Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
