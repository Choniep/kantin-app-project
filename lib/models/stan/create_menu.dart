class CreateMenu {
  final String? id;
  final String namaMakanan;
  final double harga;
  final JenisMenu jenis;
  final String? foto;
  final String? deskripsi;
  final String? idStan;

  CreateMenu({
    this.id,
    required this.namaMakanan,
    required this.harga,
    required this.jenis,
    this.foto,
    this.deskripsi,
    this.idStan,
  });

  // Enum untuk jenis menu
  factory CreateMenu.fromMap(Map<String, dynamic> map, String documentId) {
    return CreateMenu(
      id: documentId,
      namaMakanan: map['nama_makanan'] ?? '',
      harga: (map['harga'] ?? 0.0).toDouble(),
      jenis: _stringToJenisMenu(map['jenis']),
      foto: map['foto'],
      deskripsi: map['deskripsi'],
      idStan: map['id_stan'],
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
    };
  }

  // Helper method untuk konversi String ke enum JenisMenu
  static JenisMenu _stringToJenisMenu(String? jenis) {
    if (jenis == 'makanan') {
      return JenisMenu.makanan;
    } else if (jenis == 'minuman') {
      return JenisMenu.minuman;
    }
    // Default jika tidak cocok
    return JenisMenu.makanan;
  }

  // Helper method untuk konversi enum JenisMenu ke String
  static String jenisMenuToString(JenisMenu jenis) {
    return jenis.toString().split('.').last;
  }
}

// Enum untuk field jenis menu
enum JenisMenu {
  makanan,
  minuman,
}
