import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ukk_kantin/models/stan/create_menu.dart';

class DiskonService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<Diskon>> getUserDiscounts(String userId) async {
    List<Diskon> discounts = [];
    QuerySnapshot snapshot = await _firestore
        .collection('stan') // Adjust the collection path as needed
        .doc(userId)
        .collection(
            'diskon') // Assuming discounts are stored under the user's document
        .get();

    for (var doc in snapshot.docs) {
      discounts.add(Diskon.fromMap(doc.data() as Map<String, dynamic>, doc.id));
    }

    return discounts;
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
          'Checking diskon for ${menu.namaMakanan}: $isActive (now: $now, start: $startDate, end: $endDate)');
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
