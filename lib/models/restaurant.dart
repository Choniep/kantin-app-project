// ini buat data local dari menu kantin

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ukk_kantin/models/menu.dart';

class Restaurant extends ChangeNotifier {
  // list of food menu
  final List<Menu> _menu = [
    // burgers
    Menu(
      id: 123,
      name: 'Burger',
      price: 12000,
      photo: 'lib/assets/images/burgers/beef_burger.webp',
      stanId: 2,
    ),
    Menu(
      id: 123,
      name: 'Burger',
      price: 12000,
      photo: 'lib/assets/images/burgers/beef_burger.webp',
      stanId: 2,
    ),
    Menu(
      id: 123,
      name: 'Burger',
      price: 12000,
      photo: 'lib/assets/images/burgers/beef_burger.webp',
      stanId: 2,
    ),
  ];
}
