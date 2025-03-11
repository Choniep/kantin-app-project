import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class TextFieldHarga extends StatelessWidget {
  const TextFieldHarga({
    super.key,
    required TextEditingController priceController,
  }) : _priceController = priceController;

  final TextEditingController _priceController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _priceController,
      decoration: InputDecoration(
        hintText: 'Masukkan harga menu',
        prefixIcon: Icon(IconsaxPlusBold.money, color: Colors.orange[400]),
        prefixText: 'Rp ',
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
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Harga menu tidak boleh kosong';
        }
        if (double.tryParse(value) == null) {
          return 'Harga harus berupa angka';
        }
        return null;
      },
    );
  }
}
