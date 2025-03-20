import 'package:flutter/material.dart';
import 'package:ukk_kantin/models/stan/create_menu.dart';

class DiskonService {
  // Method to check if a menu has an active discount
  void checkDiskon(CreateMenu menu, List<Diskon> diskons) {
    print("running");
    DateTime now = DateTime.now();
    menu.isDiskon = diskons.any((diskon) {
      DateTime startDate = diskon.tanggalMulai;
      DateTime endDate = diskon.tanggalSelesai;
      bool isActive = now.isAfter(startDate) && now.isBefore(endDate);
      print('Checking diskon for ${menu.namaMakanan}: $isActive (now: $now, start: $startDate, end: $endDate)');
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