import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// file: lib/services/menu_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:ukk_kantin/models/stan/create_menu.dart';

class MenuService {
  final CollectionReference _menuCollection =
      FirebaseFirestore.instance.collection('menu');

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
    int? idStan,
  }) async {
    try {
      // Membuat objek Menu
      final menu = CreateMenu(
        namaMakanan: namaMakanan,
        harga: harga,
        jenis: jenis,
        foto: foto,
        deskripsi: deskripsi,
        idStan: idStan,
      );

      // Konversi ke Map dan simpan ke Firestore
      final DocumentReference docRef = await _menuCollection.add(menu.toMap());
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
  Future<bool> updateMenu(CreateMenu menu) async {
    try {
      if (menu.id != null) {
        await _menuCollection.doc(menu.id).update(menu.toMap());
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error updating menu: $e');
      return false;
    }
  }

  // Menghapus menu
  Future<bool> deleteMenu(String menuId) async {
    try {
      await _menuCollection.doc(menuId).delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting menu: $e');
      return false;
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
  Future<List<CreateMenu>> getMenusByStanId(int stanId) async {
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
}
