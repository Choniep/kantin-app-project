import 'package:flutter/material.dart';

class ButtonLogin extends StatelessWidget {
  final String hintText;
  final String? route;
  final VoidCallback? onPressed; // Custom function for flexibility

  const ButtonLogin(
      {super.key, required this.hintText, this.route, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(240, 94, 94, 1),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onPressed ??
              () {
                if (route != null) {
                  Navigator.pushNamed(context, route!);
                }
              },
          child: Text(
            hintText,
            // style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
