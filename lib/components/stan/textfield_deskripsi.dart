import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class TextFieldDeskripsi extends StatelessWidget {
  const TextFieldDeskripsi({
    super.key,
    required TextEditingController descriptionController,
  }) : _descriptionController = descriptionController;

  final TextEditingController _descriptionController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        hintText: 'Masukkan deskripsi menu',
        prefixIcon:
            Icon(IconsaxPlusBold.document_text, color: Colors.orange[400]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.orange[400]!,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      maxLines: 5,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Deskripsi menu tidak boleh kosong';
        }
        return null;
      },
    );
  }
}
