import 'package:ukk_kantin/models/discount.dart';
import 'package:ukk_kantin/models/stan/create_menu.dart';

class Menu {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String photo;
  bool isDiskon;
  final String stanId;
  final String jenisMenu;

  Menu({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.photo,
    required this.stanId,
    this.isDiskon = false, // Default value for isDiskon
    required this.jenisMenu,
  });

  // Factory constructor to create a Menu instance from a map
  factory Menu.fromMap(Map<String, dynamic> data, String documentId) {
    return Menu(
      id: documentId,
      name: data['nama'] ?? 'Unknown Menu',
      description: data['deskripsi'],
      price: (data['harga'] ?? 0).toDouble(), // Ensure price is a double
      photo: data['foto'] ?? '', // Default to empty string if no photo
      stanId: data['id_stan'] ?? "Unknown ID", // Default to 0 if no stanId
      isDiskon: data['isDiskon'] ?? false, // Default to false if not specified
      jenisMenu: data['jenis'] ?? 'Unknown', // Default to 'Unknown' if not specified
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'jenis': jenisMenu,
      'photo': photo,
      'stanId': stanId,
      'isDiskon': isDiskon,
    };
  }
}