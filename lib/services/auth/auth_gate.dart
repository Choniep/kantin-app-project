import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukk_kantin/pages/siswa/main_screen_siswa_page.dart';
import 'package:ukk_kantin/pages/stan/main_screen_page.dart';
import 'package:ukk_kantin/pages/userlogin/choice_page.dart';
import 'package:ukk_kantin/services/auth/auth_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Use provider to get auth state.
    final authService = Provider.of<AuthService>(context);
    // If not logged in, show ChoicePage.
    if (authService.currentUser == null) {
      return const ChoicePage();
    }
    // If logged in, stream Firestore data.
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(authService.currentUser!.uid)
            .snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
            return const Center(child: Text("User data tidak tersedia."));
          }
          String role = userSnapshot.data!['role'];
          if (role == 'siswa') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/screen_siswa');
            });
            return Container();
          } else if (role == 'stan') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/screen_stan');
            });
            return Container();
          }
          return const ChoicePage();
        },
      ),
    );
  }
}
