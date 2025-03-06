import 'package:flutter/material.dart';
import 'package:ukk_kantin/components/login_components/form_box_login.dart';
import 'package:ukk_kantin/services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void login() async {
    // get instance of auth service
    final _authService = AuthService();

    // try sign in
    try {
      await _authService.signInWithEmailPassword(
          _emailController.text, _passwordController.text);
    }

    // display any error
    catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                FormBoxLogin(
                  icon: Icons.home,
                  hintText: 'Email',
                  controller: _emailController,
                  ObscureText: false,
                ),
                FormBoxLogin(
                  icon: Icons.lock,
                  hintText: 'Password',
                  controller: _passwordController,
                  ObscureText: true,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // login progress
                        login();
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Belum punya akun?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/register_siswa');
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
