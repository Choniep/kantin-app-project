class CreateMenu {
  final String? id;
  final String namaMakanan;
  final double harga;
  final JenisMenu jenis;
  final String? foto;
  final String? deskripsi;
  final String? idStan;
  bool isDiskon; // Add this property

  CreateMenu({
    this.id,
    required this.namaMakanan,
    required this.harga,
    required this.jenis,
    this.foto,
    this.deskripsi,
    this.idStan,
    this.isDiskon = false, // Default value
  });

  // Factory constructor to create a CreateMenu from a map
  factory CreateMenu.fromMap(Map<String, dynamic> map, String documentId) {
    return CreateMenu(
      id: documentId,
      namaMakanan: map['nama_makanan'] ?? '',
      harga: (map['harga'] ?? 0.0).toDouble(),
      jenis: _stringToJenisMenu(map['jenis']),
      foto: map['foto'],
      deskripsi: map['deskripsi'],
      idStan: map['id_stan'],
      isDiskon: map['isDiskon'] ?? false, // Initialize from map
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama_makanan': namaMakanan,
      'harga': harga,
      'jenis': jenisMenuToString(jenis),
      'foto': foto,
      'deskripsi': deskripsi,
      'id_stan': idStan,
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

// Diskon model
class Diskon {
  DateTime tanggalMulai;
  DateTime tanggalSelesai;

  Diskon({
    required this.tanggalMulai,
    required this.tanggalSelesai,
  });
}

// Enum for menu types
enum JenisMenu {
  makanan,
  minuman,
}