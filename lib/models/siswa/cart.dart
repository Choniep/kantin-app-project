import 'package:flutter/material.dart';
import 'cart_item.dart';

class Cart with ChangeNotifier {
  List<CartItem> _items = [];
  int? _currentStanId;

  List<CartItem> get items => _items;
  int? get currentStanId => _currentStanId;

  void addItem(CartItem item) {
    // Enforce products from same booth (stan)
    if (_currentStanId != null && _currentStanId != item.menu.stanId) {
      // Optionally handle error (e.g., show warning)
      return;
    }
    _currentStanId = item.menu.stanId;
    // Check if item already exists, then update quantity; otherwise add
    int index = _items.indexWhere((ci) => ci.menu.id == item.menu.id);
    if (index != -1) {
      _items[index].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    if (_items.isEmpty) {
      _currentStanId = null;
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _currentStanId = null;
    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // New: Increment item quantity by 1
  void incrementItem(int menuId) {
    int index = _items.indexWhere((ci) => ci.menu.id == menuId);
    if (index != -1) {
      _items[index].quantity += 1;
      notifyListeners();
    }
  }

  // New: Decrement item quantity by 1; remove if quantity becomes 0
  void decrementItem(int menuId) {
    int index = _items.indexWhere((ci) => ci.menu.id == menuId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity -= 1;
      } else {
        _items.removeAt(index);
        if (_items.isEmpty) _currentStanId = null;
      }
      notifyListeners();
    }
  }
}
