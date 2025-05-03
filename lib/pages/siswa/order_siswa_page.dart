import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ukk_kantin/services/Siswa/cart_service.dart';

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

  void clearFilters() {
    setState(() {
      selectedMonth = null;
      selectedYear = null;
    });
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .update({'status': newStatus});
  }

  void showReceiptDialog(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) {
        final timestamp = order['timestamp'] as Timestamp?;
        final date = timestamp != null
            ? DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch)
            : null;
        return AlertDialog(
          title: Text('Receipt for Order ${order['order_id'] ?? order['id']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (date != null)
                Text('Date: ${date.toLocal().toString().split(' ')[0]}'),
              Text('Total Price: \$${order['totalPrice']?.toStringAsFixed(2) ?? '0.00'}'),
              Text('Status: ${order['status'] ?? 'Unknown'}'),
              // Additional receipt details can be added here
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Page'),
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
                const Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
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
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: DropdownButton<String>(
                          hint: const Text('Select Month'),
                          value: selectedMonth,
                          isExpanded: true,
                          underline: const SizedBox(),
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: DropdownButton<String>(
                          hint: const Text('Select Year'),
                          value: selectedYear,
                          isExpanded: true,
                          underline: const SizedBox(),
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
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.clear),
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
            child: StreamBuilder<List<Map<String, dynamic>>>(  
              stream: getFilteredOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading orders'));
                }
                final orders = snapshot.data ?? [];
                if (orders.isEmpty) {
                  return const Center(child: Text('No orders found'));
                }
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final timestamp = order['timestamp'] as Timestamp?;
                    final date = timestamp != null
                        ? DateTime.fromMillisecondsSinceEpoch(
                            timestamp.millisecondsSinceEpoch)
                        : null;
                    final status = order['status'] ?? 'Unknown';
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text('Order ID: ${order['order_id'] ?? order['id']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (date != null)
                              Text('Date: ${date.toLocal().toString().split(' ')[0]}'),
                            Text('Total Price: \$${order['totalPrice']?.toStringAsFixed(2) ?? '0.00'}'),
                            Text('Status: $status'),
                            if (status == 'siap diambil')
                              ElevatedButton(
                                onPressed: () async {
                                  await updateOrderStatus(order['order_id'] ?? order['id'], 'selesai');
                                  setState(() {});
                                },
                                child: const Text('ambil dan bayar'),
                              ),
                            if (status == 'selesai')
                              ElevatedButton(
                                onPressed: () {
                                  showReceiptDialog(order);
                                },
                                child: const Text('lihat struk'),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Stream<List<Map<String, dynamic>>> getFilteredOrders() {
    final query = FirebaseFirestore.instance.collection('orders');
    
    if (selectedMonth != null) {
      // Filter by month
      query.where('month', isEqualTo: selectedMonth);
    }
    
    if (selectedYear != null) {
      // Filter by year
      query.where('year', isEqualTo: selectedYear);
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
  }
}
