import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ukk_kantin/pages/siswa/main_screen_siswa_page.dart';
import 'package:ukk_kantin/pages/stan/main_screen_page.dart';
import 'package:ukk_kantin/pages/userlogin/choice_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Jika user sudah login
          if (snapshot.hasData) {
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data!.uid)
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
            );
          }
          // Jika user belum login
          return const ChoicePage();
        },
      ),
    );
  }
}
