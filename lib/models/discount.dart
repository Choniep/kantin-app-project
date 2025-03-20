import 'package:cloud_firestore/cloud_firestore.dart';

class Diskon {
  final String id; // Unique identifier for the discount
  final String namaDiskon; // Name of the discount
  final DateTime tanggalMulai; // Start date of the discount
  final DateTime tanggalBerakhir; // End date of the discount
  final int diskon; // Discount value (percentage or amount)
  final String diskonType; // Type of discount ('persen' or 'rupiah')

  Diskon({
    required this.id,
    required this.namaDiskon,
    required this.tanggalMulai,
    required this.tanggalBerakhir,
    required this.diskon,
    required this.diskonType,
  });

  // Factory method to create a Diskon from a map
  factory Diskon.fromMap(Map<String, dynamic> map, String documentId) {
    return Diskon(
      id: documentId,
      namaDiskon: map['nama_diskon'] ?? '',
      tanggalMulai: (map['tanggal_mulai'] as Timestamp).toDate(),
      tanggalBerakhir: (map['tanggal_selesai'] as Timestamp).toDate(),
      diskon: map['diskon'] ?? 0,
      diskonType: map['diskon_type'] ?? '',
    );
  }
}