import 'package:flutter/material.dart';
import 'package:ukk_kantin/services/auth/auth_service.dart';

class OrderSiswaPage extends StatelessWidget {
  const OrderSiswaPage({super.key});

  void logout() {
    final _authService = AuthService();
    _authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              logout();
            },
          ),
        ],
      ),
      body: Text('Order Page Customer'),
    );
  }
}
