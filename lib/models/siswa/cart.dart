import 'package:flutter/material.dart';
import 'cart_item.dart';

class Cart with ChangeNotifier {
  List<CartItem> _items = [];
  String? _currentStanId;

  List<CartItem> get items => _items;
  String? get currentStanId => _currentStanId;

  double get totalPrice {
    double total = 0;
    for (var item in _items) {
      total += item.totalPrice;
    }
    return total;
  }

  bool addItem(CartItem item) {
    String incomingStan = item.menu.stanId ?? 'unknown';
    debugPrint(
        "🛒 addItem called: incomingStan=$incomingStan, currentStanId=$_currentStanId");

    if (_currentStanId != null && _currentStanId != incomingStan) {
      debugPrint(
          "! Rejected add from stan $incomingStan (locked on $_currentStanId)");
      return false;
    }

    _currentStanId = incomingStan;

    int index = _items.indexWhere((ci) => ci.menu.id == item.menu.id);
    if (index != -1) {
      _items[index].quantity += item.quantity;
    } else {
      _items.add(item);
    }

    notifyListeners();
    return true;
  }

  void removeCartItem(String menuId) {
    _items.removeWhere((item) => item.menu.id == menuId);
    if (_items.isEmpty) {
      _currentStanId = null;
    }
    notifyListeners();
  }

  void updateCartItemQuantity(String menuId, int newQuantity) {
    final index = _items.indexWhere((item) => item.menu.id == menuId);
    if (index != -1) {
      if (newQuantity > 0) {
        _items[index].quantity = newQuantity;
        print(
            '🔁 Updated quantity: ${_items[index].menu.name} to $newQuantity');
      } else {
        print('🗑️ Removed item: ${_items[index].menu.name}');
        _items.removeAt(index);
        if (_items.isEmpty) _currentStanId = null;
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    _currentStanId = null;
    notifyListeners();
  }
}
