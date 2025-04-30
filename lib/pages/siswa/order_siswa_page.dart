import 'package:flutter/material.dart';
import 'package:ukk_kantin/services/auth/auth_service.dart';

class OrderSiswaPage extends StatefulWidget {
  const OrderSiswaPage({super.key});

  @override
  State<OrderSiswaPage> createState() => _OrderSiswaPageState();
}

class _OrderSiswaPageState extends State<OrderSiswaPage> {
  String? selectedMonth;
  String? selectedYear;
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  final List<String> years = ['2023', '2024', '2025'];

  void logout() {
    final authService = AuthService();
    authService.signOut();
  }

  void clearFilters() {
    setState(() {
      selectedMonth = null;
      selectedYear = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    'Filter Order',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: DropdownButton<String>(
                          hint: Text('Select Month'),
                          value: selectedMonth,
                          isExpanded: true,
                          underline: SizedBox(),
                          items: months.map((String month) {
                            return DropdownMenuItem<String>(
                              value: month,
                              child: Text(month),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              selectedMonth = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: DropdownButton<String>(
                          hint: Text('Select Year'),
                          value: selectedYear,
                          isExpanded: true,
                          underline: SizedBox(),
                          items: years.map((String year) {
                            return DropdownMenuItem<String>(
                              value: year,
                              child: Text(year),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              selectedYear = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: clearFilters,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Text('Order Page Customer'),
          ),
        ],
      ),
    );
  }
}
