import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:ukk_kantin/components/stan/profil_menu_button.dart';
import 'package:ukk_kantin/services/auth/auth_service.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  Future<void> logout(BuildContext context) async {
    final authService = AuthService();
    authService.signOut();
  Navigator.pushNamedAndRemoveUntil(context, '/choice_page', (route) => false);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profil Page'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              ProfilMenuButton(
                title: 'Edit Profil',
                icon: IconsaxPlusBold.message_edit,
                onTap: () {
                  Navigator.pushNamed(context, '/edit_stan');
                },
              ),
              ProfilMenuButton(
                title: 'Manage Discount',
                icon: IconsaxPlusBold.receipt_discount,
                onTap: () {
                  Navigator.pushNamed(context, '/manage_discount');
                },
              ),
              ProfilMenuButton(
                title: 'Manage Menu',
                icon: IconsaxPlusBold.menu,
                onTap: () {
                  Navigator.pushNamed(context, '/manage_product');
                },
              ),
              ProfilMenuButton(
                title: 'Log Out',
                icon: IconsaxPlusBold.logout,
                onTap: () {
                  logout(context);
                },
              ),
            ],
          ),
        )),
      ),
    );
  }
}
