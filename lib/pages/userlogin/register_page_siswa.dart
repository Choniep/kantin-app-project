import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ukk_kantin/components/login_components/form_box_login.dart';
import 'package:ukk_kantin/services/auth/auth_service.dart';

class RegisterPageSiswa extends StatefulWidget {
  const RegisterPageSiswa({super.key});

  @override
  State<RegisterPageSiswa> createState() => _RegisterPageSiswaState();
}

class _RegisterPageSiswaState extends State<RegisterPageSiswa> {
  // get authservice
  final _authService = AuthService();

  // ambil gambar
  final ImagePicker _picker = ImagePicker();

  // variable menyimpan gambar
  File? _imageFile;
  String? _imageUrl;

  // text editing controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // function untuk pick image
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, // Bisa pilih gallery/camera
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });

        // Upload ke Firebase Storage
        await _uploadImage();
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  // Function untuk upload image ke Firebase Storage
  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    try {
      // Buat reference ke Firebase Storage
      final String fileName =
          'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(fileName);

      // Upload file
      final UploadTask uploadTask = storageRef.putFile(_imageFile!);

      // Tunggu sampai upload selesai
      final TaskSnapshot snapshot = await uploadTask;

      // Dapatkan URL download
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _imageUrl = downloadUrl;
      });

      print('Image uploaded successfully: $_imageUrl');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  // buat register
  void register() async {
    try {
      await _authService.signUpWithEmailPassword(_emailController.text,
          _passwordController.text, _nameController.text, 'siswa');

      await _authService.createSiswaProfile(
        uid: '',
        namaSiswa: _nameController.text,
        alamat: _addressController.text,
        telp: _phoneController.text,
        fotoUrl: _imageUrl.toString(),
      );

      // create siswa
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            e.toString(),
          ),
        ),
      );
    }

    print("=== DEBUGGER ===");
    print("Nama Lengkap: $_nameController");
    print("Alamat: $_addressController");
    print("Email: $_emailController");
    print("No Telp: $_phoneController");
    print("Password: $_passwordController");
    print("Foto Profil: ${_imageFile?.path ?? 'Tidak Ada'}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register as Siswa'),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text("Bikin akun siswa"),
              // widget untuk preview image
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Stack(
                  children: [
                    // image preview
                    if (_imageFile != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: _imageFile != null
                            ? Image.file(
                                _imageFile!,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                            : Container(),
                      ),

                    // pick image button
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),

              FormBoxLogin(
                icon: Icons.man,
                hintText: 'Name',
                controller: _nameController,
                ObscureText: false,
              ),
              FormBoxLogin(
                icon: Icons.email,
                hintText: 'Email',
                controller: _emailController,
                ObscureText: false,
              ),
              FormBoxLogin(
                icon: Icons.lock,
                hintText: 'Password',
                controller: _passwordController,
                ObscureText: true,
              ),
              FormBoxLogin(
                icon: Icons.home,
                hintText: 'Address',
                controller: _addressController,
                ObscureText: false,
              ),
              FormBoxLogin(
                icon: Icons.phone,
                hintText: 'Phone Number',
                controller: _phoneController,
                ObscureText: false,
              ),

              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // register as siswa
                      register();
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sudah punya akun?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text('Login'),
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}
