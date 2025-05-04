import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:ukk_kantin/models/discount.dart';
import 'package:ukk_kantin/models/stan/create_menu.dart';

class MenuService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mendapatkan semua menu
  Future<List<CreateMenu>> getAllMenus() async {
    try {
      final QuerySnapshot stanSnapshot =
          await _firestore.collection('stan').get();

      List<CreateMenu> allMenus = [];

      for (var stanDoc in stanSnapshot.docs) {
        String stanId = stanDoc.id;
        final QuerySnapshot menuSnapshot = await _firestore
            .collection('stan')
            .doc(stanId)
            .collection('menu')
            .get();

        for (var menuDoc in menuSnapshot.docs) {
          final menuData = menuDoc.data() as Map<String, dynamic>;

          // Inject the correct stan ID
          menuData['stanId'] = stanId;

          allMenus.add(CreateMenu.fromMap(menuData, menuDoc.id));
        }
      }

      return allMenus;
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
        nama: namaMakanan,
        harga: harga,
        jenis: jenis,
        foto: foto,
        deskripsi: deskripsi,
        stanId: uid,
      );

      final DocumentReference docRef = await menuCollection.add(menu.toMap());
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
    required String stanId, // <-- pass this from your EditProductPage
  }) async {
    try {
      final Map<String, dynamic> data = {
        'nama': namaMakanan,
        'harga': harga,
        'jenis': CreateMenu.jenisMenuToString(jenis),
        'foto': foto,
        'deskripsi': deskripsi,
      };

      await _firestore
          .collection('stan')
          .doc(stanId)
          .collection('menu')
          .doc(id)
          .update(data);

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
}
