import 'package:flutter/material.dart';

class ProfilPageSiswa extends StatelessWidget {
  const ProfilPageSiswa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Siswa'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.person,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Nama Siswa',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Kelas 10',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
