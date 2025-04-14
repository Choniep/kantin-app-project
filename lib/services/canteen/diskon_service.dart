import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ukk_kantin/models/discount.dart';
import 'package:ukk_kantin/models/stan/create_menu.dart';

class DiskonService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 Future<List<Diskon>> getUserDiscounts() async {
  final uid = FirebaseAuth.instance.currentUser ?.uid;
  if (uid == null) return [];

  List<Diskon> discounts = [];

  QuerySnapshot menuSnapshot = await _firestore
      .collection('stan')
      .doc(uid)
      .collection('menu')
      .get();

  for (var menuDoc in menuSnapshot.docs) {
    String menuId = menuDoc.id;
    String menuName = (menuDoc.data() as Map<String, dynamic>?)?['nama'] ?? '';

    QuerySnapshot discountSnapshot = await menuDoc.reference.collection('diskon').get();

    for (var discountDoc in discountSnapshot.docs) {
      discounts.add(Diskon.fromMap(
        discountDoc.data() as Map<String, dynamic>,
        discountDoc.id,
        menuName,
        menuId,
      ));
    }
  }

  return discounts;
}

  Future<void> deleteDiscount(String menuId, String discountId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    await _firestore
        .collection('stan')
        .doc(uid)
        .collection('menu')
        .doc(menuId)
        .collection('diskon')
        .doc(discountId)
        .delete();
  }

  // Method to check if a menu has an active discount
  void checkDiskon(CreateMenu menu, List<Diskon> diskons) {
    print("running");
    DateTime now = DateTime.now();
    menu.isDiskon = diskons.any((diskon) {
      DateTime startDate = diskon.tanggalMulai;
      DateTime endDate = diskon.tanggalSelesai;
      bool isActive = now.isAfter(startDate) && now.isBefore(endDate);
      print(
          'Checking diskon for ${menu.nama}: $isActive (now: $now, start: $startDate, end: $endDate)');
      return isActive;
    });
  }

  // Optionally, you can create a method to check discounts for multiple menus
  void checkDiskonsForMenus(List<CreateMenu> menus, List<Diskon> diskons) {
    for (var menu in menus) {
      checkDiskon(menu, diskons);
    }
  }
}
