
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

  // Factory constructor to create a CreateMenu from a map
  factory CreateMenu.fromMap(Map<String, dynamic> map, String documentId) {
    return CreateMenu(
      id: documentId,
      nama: map['nama'] ?? '',
      harga: (map['harga'] ?? 0.0).toDouble(),
      jenis: _stringToJenisMenu(map['jenis']),
      foto: map['foto'],
      deskripsi: map['deskripsi'],
      stanId: map['stanId'],
      isDiskon: map['isDiskon'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'harga': harga,
      'jenis': jenisMenuToString(jenis),
      'foto': foto,
      'deskripsi': deskripsi,
      'stanId': stanId,
      'isDiskon': isDiskon, // Include isDiskon in the map
    };
  }

  // Helper method for converting String to enum JenisMenu
  static JenisMenu _stringToJenisMenu(String? jenis) {
    if (jenis == 'makanan') {
      return JenisMenu.makanan;
    } else if (jenis == 'minuman') {
      return JenisMenu.minuman;
    }
    // Default if not matched
    return JenisMenu.makanan;
  }

  // Helper method for converting enum JenisMenu to String
  static String jenisMenuToString(JenisMenu jenis) {
    return jenis.toString().split('.').last;
  }
}


// Enum for menu types
enum JenisMenu {
  makanan,
  minuman,
}
