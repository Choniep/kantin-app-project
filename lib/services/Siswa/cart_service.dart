import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ukk_kantin/models/menu.dart';
import 'package:ukk_kantin/models/siswa/cart_item.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _orderCollection {
    return _firestore.collection('orders');
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
      final existingQuantity =
          (snapshot.data() as Map<String, dynamic>)['quantity'] ?? 0;
      await doc.update({
        'quantity': existingQuantity + cartItem.quantity,
      });
    } else {
      await doc.set({
        'menuId': cartItem.menu.id,
        'quantity': cartItem.quantity,
        'price': cartItem.menu.price,
        'stanId': cartItem.menu.stanId,
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
            name: '',
            price: (data['price'] ?? 0).toDouble(),
            photo: '',
            stanId: data['stanId'] ?? '',
            jenisMenu: '',
          ),
          quantity: data['quantity'] ?? 1,
        );
      }).toList();
    });
  }

  Future<void> checkout(List<CartItem> cartItems) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not logged in');
      final userId = user.uid;

      final orderRef = _orderCollection.doc();
      final boothId = cartItems.isNotEmpty ? cartItems.first.menu.stanId : null;

      print('Checkout: writing stanId = $boothId');

      String? namaStan;
      if (boothId != null && boothId.isNotEmpty) {
        final stanDoc = await _firestore.collection('stan').doc(boothId).get();
        if (stanDoc.exists) {
          namaStan = stanDoc.data()?['nama_stan'] as String?;
          print('✅ Fetched nama_stan: $namaStan');
        } else {
          print('⚠️ Stan document not found for ID: $boothId');
        }
      }

      await orderRef.set({
        'order_id': orderRef.id,
        'uid': userId,
        'timestamp': FieldValue.serverTimestamp(),
        'totalPrice': cartItems.fold(
          0.0,
          (sum, item) => sum + (item.menu.price * item.quantity),
        ),
        'status': 'Sedang dimasak',
        'stanId': boothId,
        'nama_stan': namaStan ?? 'Unknown Stan',
        'month': DateTime.now().month,
        'year': DateTime.now().year,
      });

      for (var item in cartItems) {
        await orderRef.collection('menu_items').doc(item.menu.id).set({
          'menu_id': item.menu.id,
          'quantity': item.quantity,
        });
      }

      for (var item in cartItems) {
        await _cartCollection.doc(item.menu.id).delete();
      }
    } catch (e) {
      throw Exception('Checkout failed: $e');
    }
  }

  // New method to get orders for current user
  Stream<List<Map<String, dynamic>>> getOrders() async* {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      print('[getOrders] User not logged in');
      yield [];
      return;
    }

    print('[getOrders] Fetching orders for user: $userId');

    try {
      await for (var snapshot in _orderCollection
          .where('uid', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .snapshots()) {
        print('[getOrders] Orders fetched: ${snapshot.docs.length} documents');

        final orders = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          print('[getOrders] Order data: ${doc.id} => $data');
          return {'id': doc.id, ...data};
        }).toList();

        yield orders;
      }
    } catch (e) {
      print('[getOrders] Error fetching orders: $e');
      yield [];
    }
  }
}
