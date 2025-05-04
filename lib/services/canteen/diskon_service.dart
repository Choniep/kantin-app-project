import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ukk_kantin/models/discount.dart';
import 'package:ukk_kantin/models/stan/create_menu.dart';

class DiskonService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<bool> addDiscount({
    required String menuId,
    required String namaDiskon,
    required DateTime tanggalMulai,
    required DateTime tanggalSelesai,
    required int diskon,
    required String diskonType,
  }) async {
    final String uid = _auth.currentUser!.uid;
    try {
      final docRef = FirebaseFirestore.instance
          .collection('stan')
          .doc(uid)
          .collection('menu')
          .doc(menuId)
          .collection('diskon')
          .doc();

      await docRef.set({
        'nama_diskon': namaDiskon,
        'tanggal_mulai': tanggalMulai,
        'tanggal_selesai': tanggalSelesai,
        'diskon': diskon,
        'diskon_type': diskonType,
      });

      return true; // Indicate success
    } catch (e) {
      print('Error adding discount: $e');
      return false; // Indicate failure
    }
  }

  Future<List<Diskon>> getDiskonsForMenu(String menuId) async {
    final String uid = _auth.currentUser!.uid;

    List<Diskon> diskons = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('stan')
        .doc(uid)
        .collection('menu')
        .doc(menuId)
        .collection('diskon')
        .get();

    for (var doc in snapshot.docs) {
      DateTime tanggalMulai = (doc['tanggal_mulai'] as Timestamp).toDate();
      DateTime tanggalSelesai = (doc['tanggal_selesai'] as Timestamp).toDate();
      DateTime now = DateTime.now();
      bool isActive =
          now.isAfter(tanggalMulai) && now.isBefore(tanggalSelesai) ||
              now.isAtSameMomentAs(tanggalSelesai);

      diskons.add(
        Diskon(
            tanggalMulai: tanggalMulai,
            tanggalSelesai: tanggalSelesai,
            diskon: doc['diskon'],
            diskonType: doc['diskon_type'],
            id: uid,
            namaDiskon: doc['nama_diskon'],
            isActive: isActive),
      );
    }

    return diskons;
  }

  Future<List<Diskon>> getUserDiscounts() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];

    List<Diskon> discounts = [];

    QuerySnapshot menuSnapshot =
        await _firestore.collection('stan').doc(uid).collection('menu').get();

    for (var menuDoc in menuSnapshot.docs) {
      String menuId = menuDoc.id;
      String menuName =
          (menuDoc.data() as Map<String, dynamic>?)?['nama'] ?? '';

      QuerySnapshot discountSnapshot =
          await menuDoc.reference.collection('diskon').get();

      for (var discountDoc in discountSnapshot.docs) {
        discounts.add(Diskon.fromMap(
          discountDoc.data() as Map<String, dynamic>,
          discountDoc.id,
          menuName,
          menuId,
        ));
      }
    }

    return discounts;
  }

  Future<void> deleteDiscount(String menuId, String discountId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    await _firestore
        .collection('stan')
        .doc(uid)
        .collection('menu')
        .doc(menuId)
        .collection('diskon')
        .doc(discountId)
        .delete();
  }

  // Method to check if a menu has an active discount
  void checkDiskon(CreateMenu menu, List<Diskon> diskons) {
    print("running");
    DateTime now = DateTime.now();
    menu.isDiskon = diskons.any((diskon) {
      DateTime startDate = diskon.tanggalMulai;
      DateTime endDate = diskon.tanggalSelesai;
      bool isActive = now.isAfter(startDate) && now.isBefore(endDate);
      print(
          'Checking diskon for ${menu.nama}: $isActive (now: $now, start: $startDate, end: $endDate)');
      return isActive;
    });
  }

  Future<List<Diskon>> getActiveDiscount() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];

    List<Diskon> activeDiscounts = [];
    DateTime now = DateTime.now();

    QuerySnapshot menuSnapshot =
        await _firestore.collection('stan').doc(uid).collection('menu').get();

    for (var menuDoc in menuSnapshot.docs) {
      QuerySnapshot discountSnapshot =
          await menuDoc.reference.collection('diskon').get();

      for (var discountDoc in discountSnapshot.docs) {
        Diskon discount = Diskon.fromMap(
          discountDoc.data() as Map<String, dynamic>,
          discountDoc.id,
          (menuDoc.data() as Map<String, dynamic>)['nama'] ?? '',
          menuDoc.id,
        );

        // Check if the discount is active
        if (now.isAfter(discount.tanggalMulai) &&
            now.isBefore(discount.tanggalSelesai)) {
          activeDiscounts.add(discount);
        }
      }
    }

    return activeDiscounts;
  }

  // Terpakai di role siswa ketika load restaurant
  Future<void> updateStanDiscounts(String stanId) async {
    final firestore = FirebaseFirestore.instance;
    final now = DateTime.now();

    final menuSnapshot =
        await firestore.collection('stan').doc(stanId).collection('menu').get();

    for (final menuDoc in menuSnapshot.docs) {
      final menuId = menuDoc.id;
      final menuData = menuDoc.data();
      final num harga = menuData['harga'] ?? 0;
      final int originalHarga = harga.round();

      final discountRef = firestore
          .collection('stan')
          .doc(stanId)
          .collection('menu')
          .doc(menuId)
          .collection('diskon');

      final diskonSnapshot = await discountRef.get();

      bool hasActiveDiscount = false;
      num? hargaDiskon;

      for (final diskonDoc in diskonSnapshot.docs) {
        final data = diskonDoc.data();

        final Timestamp mulaiTs = data['tanggal_mulai'];
        final Timestamp selesaiTs = data['tanggal_selesai'];
        final String diskonType = data['diskon_type'];
        final num diskonValue = data['diskon'];

        final DateTime mulai = mulaiTs.toDate();
        final DateTime selesai = selesaiTs.toDate();

        final isWithinRange = now.isAfter(mulai) && now.isBefore(selesai);

        // Update isActive field on discount
        await diskonDoc.reference.update({'isActive': isWithinRange});

        if (isWithinRange) {
          hasActiveDiscount = true;

          if (diskonType == 'persen') {
            hargaDiskon = originalHarga - (originalHarga * (diskonValue / 100));
          } else if (diskonType == 'rupiah') {
            hargaDiskon = originalHarga - diskonValue;
          }

          // Apply only the first valid discount found
          break;
        }
      }

      final menuRef = firestore
          .collection('stan')
          .doc(stanId)
          .collection('menu')
          .doc(menuId);

      if (hasActiveDiscount && hargaDiskon != null) {
        await menuRef.update({
          'isDiskon': true,
          'harga_diskon':
              hargaDiskon.round(), // Optional: round for cleaner prices
        });
      } else {
        await menuRef.update({
          'isDiskon': false,
          'harga_diskon': FieldValue.delete(),
        });
      }
    }
  }
}
