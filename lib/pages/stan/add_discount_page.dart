import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ukk_kantin/services/canteen/menu_service.dart';
import 'package:ukk_kantin/models/stan/create_menu.dart';

class AddDiscountPage extends StatefulWidget {
  const AddDiscountPage({Key? key}) : super(key: key);

  @override
  _AddDiscountPageState createState() => _AddDiscountPageState();
}

class _AddDiscountPageState extends State<AddDiscountPage> {
  final MenuService _menuService = MenuService();
  late Future<List<CreateMenu>> _menusFuture;
  CreateMenu? _selectedMenu;

  // Fields for discount details
  final TextEditingController _namaDiskonController = TextEditingController();
  DateTime? _tanggalMulai;
  DateTime? _tanggalSelesai;
  final TextEditingController _diskonController = TextEditingController();
  String _diskonType = 'persen'; // Default to 'persen'
    final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _menusFuture = _menuService.getCurrentUserMenus(); // Fetch menus
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_tanggalMulai ?? DateTime.now())
          : (_tanggalSelesai ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _tanggalMulai = picked;
        } else {
          _tanggalSelesai = picked;
        }
      });
    }
  }

  Future<void> _addDiscount() async {
    // Validate fields
    if (_selectedMenu == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a menu.')),
      );
      return;
    }

    if (_selectedMenu!.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Selected menu does not have a valid ID.')),
      );
      return;
    }

    if (_namaDiskonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a discount name.')),
      );
      return;
    }

    if (_tanggalMulai == null || _tanggalSelesai == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both dates.')),
      );
      return;
    }

    if (_tanggalMulai!.isAfter(_tanggalSelesai!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Tanggal Mulai must be before Tanggal Selesai.')),
      );
      return;
    }

    final String namaDiskon = _namaDiskonController.text;
    final int diskonValue = int.tryParse(_diskonController.text) ?? 0;

    // Validate discount value based on the selected type
    if (_diskonType == 'persen' && diskonValue > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Discount cannot be more than 100% when using persen.')),
      );
      return;
    }

    if (_diskonType == 'rupiah' && diskonValue > _selectedMenu!.harga) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Discount cannot exceed the menu price when using rupiah.')),
      );
      return;
    }

    if (diskonValue <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid discount value.')),
      );
      return;
    }
     logger.i('Adding discount: $namaDiskon, Amount: $diskonValue, Type: $_diskonType, Menu ID: ${_selectedMenu!.id}');


    // Assuming you have a method in MenuService to upload the discount
    final success = await _menuService.addDiscount(
      menuId: _selectedMenu!.id!, // Use the non-null assertion operator
      namaDiskon: namaDiskon,
      tanggalMulai: _tanggalMulai!,
      tanggalSelesai: _tanggalSelesai!,
      diskon: diskonValue,
      diskonType: _diskonType,
    );

    if (success) {
      print("Raja jawa: $_selectedMenu");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Discount added successfully!')),
      );
      // Optionally, you can navigate back or clear the form
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add discount.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Discount'),
      ),
      body: Center(
        child: FutureBuilder<List<CreateMenu>>(
          future: _menusFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading menus'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No menus available'));
            }

            final menus = snapshot.data!;

            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
              child: Column(
                children: [
                  // Dropdown for menu selection
                  Container(
                    child: Column(
                      children: [
                        const Text("Nama Menu:"),
                        DropdownButton<CreateMenu>(
                          hint: const Text('Pilih Menu'),
                          value: _selectedMenu,
                          onChanged: (CreateMenu? newValue) {
                            setState(() {
                              _selectedMenu = newValue;
                            });
                          },
                          items: menus.map<DropdownMenuItem<CreateMenu>>(
                              (CreateMenu menu) {
                            return DropdownMenuItem<CreateMenu>(
                              value: menu,
                              child: Text(
                                  '${menu.namaMakanan} - Rp ${menu.harga}'),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Fields for discount details
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _namaDiskonController,
                          decoration:
                              const InputDecoration(labelText: 'Nama Diskon'),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text("Pilih Tanggal Mulai"),
                                  GestureDetector(
                                    onTap: () => _selectDate(context, true),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _tanggalMulai != null
                                              ? "${_tanggalMulai!.toLocal()}"
                                                  .split(' ')[0]
                                              : 'Pilih Tanggal',
                                          style: TextStyle(
                                            color: _tanggalMulai != null
                                                ? Colors.black
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                children: [
                                  Text("Pilih Tanggal Selesai"),
                                  GestureDetector(
                                    onTap: () => _selectDate(context, false),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _tanggalSelesai != null
                                              ? "${_tanggalSelesai!.toLocal()}"
                                                  .split(' ')[0]
                                              : 'Pilih Tanggal',
                                          style: TextStyle(
                                            color: _tanggalSelesai != null
                                                ? Colors.black
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _diskonController,
                          decoration:
                              const InputDecoration(labelText: 'Diskon'),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio<String>(
                              value: 'persen',
                              groupValue: _diskonType,
                              onChanged: (String? value) {
                                setState(() {
                                  _diskonType = value!;
                                });
                              },
                            ),
                            const Text('Persen'),
                            Radio<String>(
                              value: 'rupiah',
                              groupValue: _diskonType,
                              onChanged: (String? value) {
                                setState(() {
                                  _diskonType = value!;
                                });
                              },
                            ),
                            const Text('Rupiah'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addDiscount, // Call the add discount function
                    child: const Text('Add Discount'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
