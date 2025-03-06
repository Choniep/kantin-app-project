import 'package:flutter/material.dart';
import 'package:ukk_kantin/pages/siswa/home_page_siswa.dart';
import 'package:ukk_kantin/pages/siswa/order_siswa_page.dart';

class MainScreenCustomerPage extends StatefulWidget {
  const MainScreenCustomerPage({super.key});

  @override
  State<MainScreenCustomerPage> createState() => _MainScreenCustomerPageState();
}

class _MainScreenCustomerPageState extends State<MainScreenCustomerPage> {
  int _selectedIndex = 0;

  // list halaman yang akan ditampilkan
  static final List<Widget> _pages = <Widget>[
    const HomePageSiswa(),
    const OrderSiswaPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Order',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
