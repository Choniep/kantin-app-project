import 'package:flutter/material.dart';
import 'cart_item.dart';

class Cart with ChangeNotifier {
  List<CartItem> _items = [];
  int? _currentStanId;

  List<CartItem> get items => _items;
  int? get currentStanId => _currentStanId;
  double get totalPrice => totalPrice;

  void addItem(CartItem item) {
    // Enforce products from same booth (stan)
    if (_currentStanId != null && _currentStanId != item.menu.stanId) {
      // Optionally handle error (e.g., show warning)
      return;
    }
    _currentStanId = int.parse(item.menu.stanId);
    // Check if item already exists, then update quantity; otherwise add
    int index = _items.indexWhere((ci) => ci.menu.id == item.menu.id);
    if (index != -1) {
      // If item already exists, update its quantity
      _items[index].quantity += item.quantity;
    } else {
      // If it's a new item, add it to the cart
      _items.add(item);
    }

    // Notify listeners to update UI
    notifyListeners();
  }

  /// Removes item by [menuId]
  void removeCartItem(String menuId) {
    _items.removeWhere((item) => item.menu.id == menuId);
    if (_items.isEmpty) {
      _currentStanId = null;
    }
    notifyListeners();
  }

  /// Updates the quantity of an item
  void updateCartItemQuantity(String menuId, int newQuantity) {
    int index = _items.indexWhere((item) => item.menu.id == menuId);
    if (index != -1) {
      if (newQuantity > 0) {
        _items[index].quantity = newQuantity;
      } else {
        _items.removeAt(index);
        if (_items.isEmpty) _currentStanId = null;
      }
      notifyListeners();
    }
  }

  /// Clears the cart entirely
  void clear() {
    _items.clear();
    _currentStanId = null;
    notifyListeners();
  }
}
