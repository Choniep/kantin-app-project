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
  final double? diskon;
  final String? jenisDiskon;
  final double? hargaDiskon;

  Menu(
      {required this.id,
      required this.name,
      this.description,
      required this.price,
      required this.photo,
      required this.stanId,
      this.isDiskon = false,
      required this.jenisMenu,
      this.diskon,
      this.jenisDiskon,
      this.hargaDiskon});

  factory Menu.fromMap(Map<String, dynamic> data, String documentId) {
    return Menu(
      id: documentId,
      name: data['nama'] ?? 'Unknown Menu',
      description: data['deskripsi'],
      price: (data['harga'] as num?)?.toDouble() ?? 0.0,
      photo: data['foto'] ?? '',
      stanId: data['stanId'] ?? 'Unknown Stan',
      isDiskon: data['isDiskon'] ?? false,
      jenisMenu: data['jenis'] ?? 'Unknown',
      diskon: data['diskon']?.toDouble(),
      jenisDiskon: data['diskon_type'],
      hargaDiskon: data['harga_diskon']?.toDouble(),
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
      'diskon': diskon,
      'diskon_type': jenisDiskon,
      'harga_diskon': hargaDiskon,
    };
  }

  // Override equality operator to compare by ID
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Menu && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
