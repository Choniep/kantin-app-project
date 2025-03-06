import 'package:flutter/material.dart';

class HomePageSiswa extends StatefulWidget {
  const HomePageSiswa({super.key});

  @override
  State<HomePageSiswa> createState() => _HomePageSiswaState();
}

class _HomePageSiswaState extends State<HomePageSiswa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page Customer'),
      ),
      body: Center(
        child: Text('Home Page Customer'),
      ),
    );
  }
}
