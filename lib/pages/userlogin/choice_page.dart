import 'package:flutter/material.dart';
import 'package:ukk_kantin/components/login_components/button_login.dart';
import 'package:ukk_kantin/components/login_components/choice_options.dart';

class ChoicePage extends StatefulWidget {
  const ChoicePage({super.key});

  @override
  State<ChoicePage> createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage> {
  String? selectedRole;

  void onRoleSelected(String role) {
    setState(() {
      selectedRole = role;
    });
  }

  void navigateToNextPage() {
    if (selectedRole == 'siswa') {
      Navigator.pushNamed(context, '/register_siswa');
    } else if (selectedRole == 'stan') {
      Navigator.pushNamed(context, '/register_stan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pilih Login',
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Siapa kamu?',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w800)),
                SizedBox(
                  height: 40,
                ),
                ChoiceOptions(
                  icon: Icons.man,
                  role: "siswa",
                  isSelected: selectedRole == "siswa",
                  onSelected: () => onRoleSelected("siswa"),
                ),
                SizedBox(
                  height: 24,
                ),
                ChoiceOptions(
                  icon: Icons.cabin,
                  role: "stan",
                  isSelected: selectedRole == "stan",
                  onSelected: () => onRoleSelected("stan"),
                ),
                SizedBox(height: 30),
                selectedRole != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedRole == "siswa" ? "Siswa" : "Admin Stan",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                            // style: GoogleFonts.outfit(
                            //     fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            selectedRole == "siswa"
                                ? "Sebagai siswa kamu harus mematuhi peraturan yang sudah ditetapkan oleh sekolah tentang peraturan yang ada di kantin."
                                : "Sebagai pemilik stan kamu harus mematuhi peraturan yang sudah ditetapkan oleh sekolah.",
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
                Expanded(child: Container()),
                selectedRole != null
                    ? ButtonLogin(
                        hintText: "Next",
                        onPressed: navigateToNextPage,
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
