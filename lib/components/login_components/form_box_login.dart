import 'package:flutter/material.dart';

class FormBoxLogin extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController? controller;
  final bool ObscureText;

  const FormBoxLogin({
    super.key,
    required this.icon,
    required this.hintText,
    required this.controller,
    required this.ObscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: ObscureText,
      controller: controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(117, 134, 146, 1)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromRGBO(117, 134, 146, 1), width: 2),
          ),
          prefixIcon: Icon(
            icon,
            color: Color.fromRGBO(240, 94, 94, 1),
          ),
          hintText: hintText,
          // hintStyle: GoogleFonts.nunitoSans(
          //     fontSize: 12,
          //     fontWeight: FontWeight.w600,
          //     color: Color.fromRGBO(117, 134, 146, 1)),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16)),
    );
  }
}
