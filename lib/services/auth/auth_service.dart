import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? currentUser;

  // Updated constructor to listen for auth state changes.
  AuthService() {
    _firebaseAuth.authStateChanges().listen((user) {
      currentUser = user;
      notifyListeners();
    });
  }

  String? currentUserId; // buat simpen UID

  // sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      // sign user in
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      currentUserId = userCredential.user!.uid;

      // fetch user role from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      String role = userDoc['role'];

      // return user credential along with role
      return userCredential;
    }

    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sign up
  Future<UserCredential> signUpWithEmailPassword(
      String email, password, username, role) async {
    try {
      // sign user up
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // take user UID
      String uid = userCredential.user!.uid;

      // simpen UID
      currentUserId = userCredential.user!.uid;

      // save to Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'username': username,
        'email': email,
        'role': role,
        'id': uid,
        'createdAt': DateTime.now(),
      });

      return userCredential;
    }

    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // check if profile exist
  Future<bool> checkProfileExists(String uid, String role) async {
    try {
      final collection = role == 'siswa' ? 'siswa' : 'stan';
      final doc = await _firestore.collection(collection).doc(uid).get();
      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }

  // Create Siswa Profile
  Future<void> createSiswaProfile({
    required String uid,
    required String namaSiswa,
    required String alamat,
    required String telp,
    String? fotoUrl,
  }) async {
    try {
      // Dapatkan user yang sedang login
      User? user = _firebaseAuth.currentUser;

      if (user == null) {
        throw Exception("User is not logged in");
      }

      String uid = user.uid; // Ambil UID dari user yang login

      await _firestore.collection('siswa').doc(uid).set({
        'uid': uid,
        'nama_siswa': namaSiswa,
        'alamat': alamat,
        'telp': telp,
        'foto': fotoUrl,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Create Stan Profile
  Future<void> createStanProfile({
    required String uid,
    required String namaStan,
    required String namaPemilik,
    required String telp,
  }) async {
    try {
      // Dapatkan user yang sedang login
      User? user = _firebaseAuth.currentUser;

      if (user == null) {
        throw Exception("User is not logged in");
      }

      String uid = user.uid; // Ambil UID dari user yang login

      await _firestore.collection('stan').doc(uid).set({
        'uid': uid,
        'nama_stan': namaStan,
        'nama_pemilik': namaPemilik,
        'telp': telp,
      });
    } catch (e) {
      rethrow;
    }
  }

  // sign out
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
