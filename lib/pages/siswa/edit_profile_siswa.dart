import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditPageSiswa extends StatefulWidget {
  const EditPageSiswa({super.key});

  @override
  State<EditPageSiswa> createState() => _EditPageSiswaState();
}

class _EditPageSiswaState extends State<EditPageSiswa> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _telpController = TextEditingController();
  final _fotoController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('siswa').doc(uid).get();
    final data = doc.data();
    if (data != null) {
      _namaController.text = data['nama_siswa'] ?? '';
      _alamatController.text = data['alamat'] ?? '';
      _telpController.text = data['telp'] ?? '';
      _fotoController.text = data['foto'] ?? '';
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('siswa').doc(uid).update({
      'nama_siswa': _namaController.text,
      'alamat': _alamatController.text,
      'telp': _telpController.text,
      'foto': _fotoController.text,
    });

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Profil berhasil diperbarui')),
      );
      Navigator.pop(context); // back to profile page
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _telpController.dispose();
    _fotoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil Siswa'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _namaController,
                      decoration:
                          const InputDecoration(labelText: 'Nama Siswa'),
                      validator: (value) =>
                          value!.isEmpty ? 'Tidak boleh kosong' : null,
                    ),
                    TextFormField(
                      controller: _alamatController,
                      decoration: const InputDecoration(labelText: 'Alamat'),
                      validator: (value) =>
                          value!.isEmpty ? 'Tidak boleh kosong' : null,
                    ),
                    TextFormField(
                      controller: _telpController,
                      decoration:
                          const InputDecoration(labelText: 'No. Telepon'),
                      validator: (value) =>
                          value!.isEmpty ? 'Tidak boleh kosong' : null,
                      keyboardType: TextInputType.phone,
                    ),
                    TextFormField(
                      controller: _fotoController,
                      decoration:
                          const InputDecoration(labelText: 'URL Foto Profil'),
                      validator: (value) =>
                          value!.isEmpty ? 'Tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _saveProfile,
                      child: const Text('Simpan'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
