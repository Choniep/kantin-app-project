import 'package:cloud_firestore/cloud_firestore.dart';

class Diskon {
  final String id; // Unique identifier for the discount
  final String namaDiskon; // Name of the discount
  final DateTime tanggalMulai; // Start date of the discount
  final DateTime tanggalSelesai; // End date of the discount
  final int diskon; // Discount value (percentage or amount)
  final String diskonType;
  final String? menuName;
  final String? menuId;
  bool isActive = false;

  Diskon({
    required this.id,
    required this.namaDiskon,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.diskon,
    required this.diskonType,
    this.menuName,
    this.menuId,
    required this.isActive,
  });

  // Factory method to create a Diskon from a map
  factory Diskon.fromMap(Map<String, dynamic> map, String documentId, [String? menuName, String? menuId]) {
    return Diskon(
      id: documentId,
      namaDiskon: map['nama_diskon'] ?? '',
      tanggalMulai: (map['tanggal_mulai'] as Timestamp).toDate(),
      tanggalSelesai: (map['tanggal_selesai'] as Timestamp).toDate(),
      diskon: map['diskon'] ?? 0,
      diskonType: map['diskon_type'] ?? '',
      menuName: menuName,
      menuId: menuId,
      isActive: false,

    );
  }
}