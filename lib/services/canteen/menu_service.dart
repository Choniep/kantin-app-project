import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:ukk_kantin/models/stan/create_menu.dart';

class MenuService {
  final CollectionReference _menuCollection =
      FirebaseFirestore.instance.collection('menu');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mendapatkan semua menu
  Future<List<CreateMenu>> getAllMenus() async {
    try {
      final QuerySnapshot snapshot = await _menuCollection.get();
      return snapshot.docs.map((doc) {
        return CreateMenu.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      debugPrint('Error getting all menus: $e');
      return [];
    }
  }

  // Menambahkan menu baru
  Future<String?> addMenu({
    required String namaMakanan,
    required double harga,
    required JenisMenu jenis,
    String? foto,
    String? deskripsi,
    String? idStan,
  }) async {
    final String uid = _auth.currentUser!.uid;

    try {
      if (uid.isEmpty) {
        debugPrint('No user is currently signed in.');
        return null;
      }

      final CollectionReference menuCollection =
          _firestore.collection("stan").doc(uid).collection("menu");

      final menu = CreateMenu(
        namaMakanan: namaMakanan,
        harga: harga,
        jenis: jenis,
        foto: foto,
        deskripsi: deskripsi,
        idStan: uid,
      );

      final DocumentReference docRef = await menuCollection.add(menu.toMap());
      return docRef.id;
    } catch (e) {
      debugPrint('Error adding menu: $e');
      return null;
    }
  }

  // Atau alternatif lain: menerima objek Menu langsung
  Future<String?> addMenuObject(CreateMenu menu) async {
    try {
      final DocumentReference docRef = await _menuCollection.add(menu.toMap());
      return docRef.id;
    } catch (e) {
      debugPrint('Error adding menu: $e');
      return null;
    }
  }

  // Memperbarui menu
  Future<String?> updateMenu({
    required String id,
    required String namaMakanan,
    required double harga,
    required JenisMenu jenis,
    String? foto,
    String? deskripsi,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'nama_makanan': namaMakanan,
        'harga': harga,
        'jenis': CreateMenu.jenisMenuToString(jenis),
        'foto': foto,
        'deskripsi': deskripsi,
      };

      await _menuCollection.doc(id).update(data);
      return id;
    } catch (e) {
      debugPrint('Error updating menu: $e');
      return null;
    }
  }

  // Menghapus menu
  Future<bool> deleteMenu(String menuId) async {
    try {
      final String uid = _auth.currentUser!.uid;
      final DocumentReference menuDoc =
          _firestore.collection("stan").doc(uid).collection("menu").doc(menuId);

      await menuDoc.delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting menu: $e');
      return false;
    }
  }

  Future<List<CreateMenu>> getCurrentUserMenus() async {
    final String uid = _auth.currentUser!.uid;

    try {
      final CollectionReference menuCollection =
          _firestore.collection("stan").doc(uid).collection("menu");

      final QuerySnapshot querySnapshot = await menuCollection.get();

      final List<CreateMenu> menus = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return CreateMenu.fromMap(data, doc.id);
      }).toList();

      return menus;
    } catch (e) {
      debugPrint('Error getting menus: $e');
      return [];
    }
  }

  // Mendapatkan menu berdasarkan jenis
  Future<List<CreateMenu>> getMenusByType(JenisMenu jenisMenu) async {
    try {
      final QuerySnapshot snapshot = await _menuCollection
          .where('jenis', isEqualTo: CreateMenu.jenisMenuToString(jenisMenu))
          .get();

      return snapshot.docs.map((doc) {
        return CreateMenu.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      debugPrint('Error getting menus by type: $e');
      return [];
    }
  }

  // Mendapatkan menu berdasarkan ID stan
  Future<List<CreateMenu>> getMenusByStanId(String stanId) async {
    try {
      final QuerySnapshot snapshot =
          await _menuCollection.where('id_stan', isEqualTo: stanId).get();

      return snapshot.docs.map((doc) {
        return CreateMenu.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      debugPrint('Error getting menus by stan ID: $e');
      return [];
    }
  }

  // Mencari menu berdasarkan nama
  Future<List<CreateMenu>> searchMenus(String keyword) async {
    try {
      // Firestore tidak mendukung search seperti SQL LIKE
      // Kita perlu mengambil semua data dan filter di client
      // Atau menggunakan Firestore extensions seperti Algolia
      final QuerySnapshot snapshot = await _menuCollection.get();

      return snapshot.docs
          .map((doc) =>
              CreateMenu.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .where((menu) =>
              menu.namaMakanan.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    } catch (e) {
      debugPrint('Error searching menus: $e');
      return [];
    }
  }

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
  List<Diskon> diskons = [];
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('menu')
      .doc(menuId)
      .collection('diskon')
      .get();

  for (var doc in snapshot.docs) {
    DateTime tanggalMulai = (doc['tanggal_mulai'] as Timestamp).toDate();
    DateTime tanggalBerakhir = (doc['tanggal_berakhir'] as Timestamp).toDate();
    diskons.add(Diskon(tanggalMulai: tanggalMulai, tanggalBerakhir: tanggalBerakhir));
  }

  return diskons;
}
}
