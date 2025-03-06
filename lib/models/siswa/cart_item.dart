import 'package:ukk_kantin/models/menu.dart';

class CartItem {
  Menu menu;
  int quantity;

  CartItem({
    required this.menu,
    this.quantity = 1,
  });

  double get totalPrice {
    return menu.price * quantity;
  }
}
