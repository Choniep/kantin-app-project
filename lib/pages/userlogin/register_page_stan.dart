import 'package:flutter/material.dart';
import 'package:ukk_kantin/services/auth/auth_service.dart';

class RegisterPageStan extends StatefulWidget {
  const RegisterPageStan({super.key});

  @override
  State<RegisterPageStan> createState() => _RegisterPageStanState();
}

class _RegisterPageStanState extends State<RegisterPageStan> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _stanNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _stanNameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // get authservice
  final _authService = AuthService();

  // buat register
  void register() async {
    try {
      await _authService.signUpWithEmailPassword(_emailController.text,
          _passwordController.text, _nameController.text, 'stan');

      await _authService.createStanProfile(
        uid: '',
        namaStan: _stanNameController.text,
        namaPemilik: _nameController.text,
        telp: _phoneController.text,
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
  }

  @override
  void dispose() {
    _nameController.dispose();
    _stanNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocusNode.dispose();
    _stanNameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register as Stan'),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('daftar sebagai stan'),
            TextField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: _stanNameController,
              focusNode: _stanNameFocusNode,
              decoration: const InputDecoration(
                labelText: 'Stan Name',
              ),
            ),
            TextField(
              controller: _phoneController,
              focusNode: _phoneFocusNode,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            TextField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // register as stan
                    register();
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sudah punya akun?'),
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
    );
  }
}
