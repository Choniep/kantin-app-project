import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:ukk_kantin/components/stan/profil_menu_button.dart';
import 'package:ukk_kantin/services/auth/auth_service.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  void logout() {
    final _authService = AuthService();
    _authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Page'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              ProfilMenuButton(
                title: 'Ubah Profil',
                icon: IconsaxPlusBold.message_edit,
                onTap: () {},
              ),
              ProfilMenuButton(
                title: 'Manage Diskon',
                icon: IconsaxPlusBold.receipt_discount,
                onTap: () {
                  Navigator.pushNamed(context, '/manage_discount');
                },
              ),
              ProfilMenuButton(
                title: 'Manage Menu',
                icon: IconsaxPlusBold.menu,
                onTap: () {
                  Navigator.pushNamed(context, '/add_product');
                },
              ),
              ProfilMenuButton(
                title: 'Log Out',
                icon: IconsaxPlusBold.logout,
                onTap: () {
                  logout();
                },
              ),
            ],
          ),
        )),
      ),
    );
  }
}
