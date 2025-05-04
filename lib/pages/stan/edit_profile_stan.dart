import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditPageStan extends StatefulWidget {
  const EditPageStan({super.key});

  @override
  State<EditPageStan> createState() => _EditPageStanState();
}

class _EditPageStanState extends State<EditPageStan> {
  final _formKey = GlobalKey<FormState>();
  final _namaPemilikController = TextEditingController();
  final _namaStanController = TextEditingController();
  final _telpController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('stan').doc(uid).get();
      final data = doc.data();
      if (data != null) {
        _namaPemilikController.text = data['nama_pemilik'] ?? '';
        _namaStanController.text = data['nama_stan'] ?? '';
        _telpController.text = data['telp'] ?? '';
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('akun').doc(uid).update({
        'nama_pemilik': _namaPemilikController.text,
        'nama_stan': _namaStanController.text,
        'telp': _telpController.text,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Profil stan berhasil diperbarui')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _namaPemilikController.dispose();
    _namaStanController.dispose();
    _telpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil Stan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaPemilikController,
                decoration: const InputDecoration(labelText: 'Nama Pemilik'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _namaStanController,
                decoration: const InputDecoration(labelText: 'Nama Stan'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _telpController,
                decoration: const InputDecoration(labelText: 'Telepon'),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Tidak boleh kosong' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
