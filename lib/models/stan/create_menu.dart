// Enum for menu types
enum JenisMenu {
  makanan,
  minuman,
}

class CreateMenu {
  final String? id;
  final String nama;
  final double harga;
  final JenisMenu jenis;
  final String? foto;
  final String? deskripsi;
  final String? stanId;
  bool isDiskon;

  CreateMenu({
    this.id,
    required this.nama,
    required this.harga,
    required this.jenis,
    this.foto,
    this.deskripsi,
    this.stanId,
    this.isDiskon = false,
  });

  /// Factory constructor to create a CreateMenu instance from Firestore Map
  factory CreateMenu.fromMap(Map<String, dynamic> map, String documentId) {
    return CreateMenu(
      id: documentId,
      nama: map['nama'] ?? '',
      harga: (map['harga'] as num?)?.toDouble() ?? 0.0,
      jenis: _stringToJenisMenu(map['jenis']),
      foto: map['foto'],
      deskripsi: map['deskripsi'],
      stanId: map['stanId'],
      isDiskon: map['isDiskon'] ?? false,
    );
  }

  /// Convert CreateMenu instance to Firestore-compatible Map
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'harga': harga,
      'jenis': jenisMenuToString(jenis),
      'foto': foto,
      'deskripsi': deskripsi,
      'stanId': stanId,
      'isDiskon': isDiskon,
    };
  }

  /// Convert string to JenisMenu enum
  static JenisMenu _stringToJenisMenu(String? jenis) {
    switch (jenis) {
      case 'minuman':
        return JenisMenu.minuman;
      case 'makanan':
      default:
        return JenisMenu.makanan;
    }
  }

  /// Convert JenisMenu enum to string
  static String jenisMenuToString(JenisMenu jenis) {
    return jenis.toString().split('.').last;
  }
}
