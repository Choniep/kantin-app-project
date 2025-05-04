import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ukk_kantin/services/auth/auth_service.dart';

class ProfilPageSiswa extends StatelessWidget {
  const ProfilPageSiswa({super.key});

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception("User not logged in");
    }

    return await FirebaseFirestore.instance.collection('siswa').doc(uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profil Siswa'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authService = AuthService();
              await authService.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/choice_page', (route) => false);
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User data not found'));
          }

          final data = snapshot.data!.data()!;
          final nama = data['nama_siswa'] ?? 'Nama Siswa';
          final alamat = data['alamat'] ?? 'Alamat belum diisi';
          final telp = data['telp'] ?? 'Nomor telepon belum diisi';
          final foto = data['foto'] ?? '';

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                foto.isNotEmpty
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(foto),
                      )
                    : const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        child:
                            Icon(Icons.person, size: 50, color: Colors.white),
                      ),
                const SizedBox(height: 16),
                Text(
                  nama,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(alamat),
                const SizedBox(height: 4),
                Text(telp),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/edit_siswa');
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profil'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
