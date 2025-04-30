import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ukk_kantin/models/menu.dart';
import 'package:ukk_kantin/models/siswa/cart_item.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _orderCollection {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception('User not logged in');
    }
    return _firestore.collection('siswa').doc(uid).collection('order');
  }

  CollectionReference get _cartCollection {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception('User not logged in');
    }
    return _firestore.collection('siswa').doc(uid).collection('cart');
  }

  Future<void> addCartItem(CartItem cartItem) async {
    final doc = _cartCollection.doc(cartItem.menu.id);
    final snapshot = await doc.get();
    if (snapshot.exists) {
      // If item exists, update quantity
      final existingQuantity =
          (snapshot.data() as Map<String, dynamic>)['quantity'] ?? 0;
      await doc.update({
        'quantity': existingQuantity + cartItem.quantity,
      });
    } else {
      // Add new item
      await doc.set({
        'menuId': cartItem.menu.id,
        'quantity': cartItem.quantity,
        'price': cartItem.menu.price,
        'stanId': cartItem.menu.stanId,  // Save stanId
      });
    }
  }

  Future<void> updateCartItemQuantity(String menuId, int quantity) async {
    final doc = _cartCollection.doc(menuId);
    if (quantity <= 0) {
      await doc.delete();
    } else {
      await doc.update({'quantity': quantity});
    }
  }

  Future<void> removeCartItem(String menuId) async {
    final doc = _cartCollection.doc(menuId);
    await doc.delete();
  }

  Stream<List<CartItem>> getCartItems() {
    return _cartCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return CartItem(
          menu: Menu(
            id: data['menuId'],
            name: '', // Name not stored here, can be fetched separately if needed
            price: (data['price'] ?? 0).toDouble(),
            photo: '',
            stanId: data['stanId'] ?? '', // Include stanId here
            jenisMenu: '',
          ),
          quantity: data['quantity'] ?? 1,
        );
      }).toList();
    });
  }

  // Checkout function
  Future<void> checkout(List<CartItem> cartItems) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }
      final userId = user.uid;

      // Create a new order document in the Firestore orders collection
      DocumentReference orderRef = await _orderCollection.add({
        'order_id': _generateOrderId(),
        'timestamp': FieldValue.serverTimestamp(),
        'totalPrice': cartItems.fold(
            0.0, (sum, item) => sum + (item.menu.price * item.quantity)),
      });

      // Add the menu items as sub-collection of this order
      for (var item in cartItems) {
        await orderRef.collection('menu_items').add({
          'menu_id': item.menu.id,
          'quantity': item.quantity,
          'stan_id': item.menu.stanId, // Add stanId to each menu item
          'status': 'pending', // Default status
        });
      }

      // Optionally, delete the cart items after order is placed
      for (var item in cartItems) {
        await _cartCollection.doc(item.menu.id).delete();
      }
    } catch (e) {
      throw Exception('Checkout failed: $e');
    }
  }

  // Helper function to generate order ID (can be customized as needed)
  String _generateOrderId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
