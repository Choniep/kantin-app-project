import 'package:ukk_kantin/models/discount.dart';

class Menu {
  final int id;
  final String name;
  final String? description;
  final double price;
  final String type;
  final String photo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int stanId;
  final Discount? discount;

  Menu({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.type,
    required this.photo,
    required this.createdAt,
    required this.updatedAt,
    required this.stanId,
    required this.discount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'type': type,
      'photo': photo,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'stanId': stanId,
    };
  }
}
