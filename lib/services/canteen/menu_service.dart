import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MenuService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addMenu({
    required String name,
    required String description,
    required double price,
    required File image,
  }) async {
    try {
      final ref = _storage.ref().child('menu_images/$name');
      await ref.putFile(image);
      final imageUrl = await ref.getDownloadURL();

      await _firestore.collection('menu').add({
        'name': name,
        'description': description,
        'price': price,
        'image': imageUrl,
      });
    } on FirebaseException catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> updateMenu({
    required String id,
    required String name,
    required String description,
    required double price,
    required File image,
  }) async {
    try {
      final ref = _storage.ref().child('menu_images/$name');
      await ref.putFile(image);
      final imageUrl = await ref.getDownloadURL();

      await _firestore.collection('menu').doc(id).update({
        'name': name,
        'description': description,
        'price': price,
        'image': imageUrl,
      });
    } on FirebaseException catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> deleteMenu(String id) async {
    try {
      await _firestore.collection('menu').doc(id).delete();
    } on FirebaseException catch (e) {
      debugPrint('Error: $e');
    }
  }
}
