import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  String? selectedMonth;
  int selectedYear = DateTime.now().year;

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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<QueryDocumentSnapshot>> getOrdersStream() async* {
    String? uid = _auth.currentUser?.uid;
    if (uid == null) {
      yield [];
      return;
    }

    QuerySnapshot snapshot = await _firestore
        .collection('orders')
        .where('stanId', isEqualTo: uid)
        .get();

    DateTime startDate;
    DateTime endDate;

    if (selectedMonth != null) {
      int monthIndex = months.indexOf(selectedMonth!) + 1;
      startDate = DateTime(selectedYear, monthIndex, 1);
      endDate = (monthIndex < 12)
          ? DateTime(selectedYear, monthIndex + 1, 1)
          : DateTime(selectedYear + 1, 1, 1);
    } else {
      startDate = DateTime(selectedYear, 1, 1);
      endDate = DateTime(selectedYear + 1, 1, 1);
    }

    List<QueryDocumentSnapshot> filtered = snapshot.docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final ts = data['timestamp'];
      if (ts is Timestamp) {
        final date = ts.toDate();
        return date.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
            date.isBefore(endDate);
      }
      return false;
    }).toList();

    yield filtered;
  }

  Future<String> getSiswaName(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('siswa').doc(uid).get();
    if (doc.exists) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      return data?['nama_siswa'] ?? 'Unknown Siswa';
    }
    return 'Unknown Siswa';
  }

  Future<List<Map<String, dynamic>>> getMenuItems(String orderId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('orders')
        .doc(orderId)
        .collection('menu_items')
        .get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  void updateOrderStatus(String orderId) async {
    await _firestore
        .collection('orders')
        .doc(orderId)
        .update({'status': 'siap diambil'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 15),
            width: double.infinity,
            child: const Text(
              'Order History Page',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1, thickness: 1),

          // Filters
          Container(
            color: Colors.grey.shade300,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Orders',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    // Month Picker
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Month', style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: InkWell(
                              onTap: _showMonthPicker,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        size: 18, color: Colors.grey.shade700),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        selectedMonth ?? 'Select',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: selectedMonth == null
                                              ? Colors.black87
                                              : Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(Icons.keyboard_arrow_down,
                                        size: 18, color: Colors.grey.shade700),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Year Picker
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Year', style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: InkWell(
                              onTap: _showYearPicker,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        size: 18, color: Colors.grey.shade700),
                                    const SizedBox(width: 8),
                                    Text(
                                      selectedYear.toString(),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const Spacer(),
                                    Icon(Icons.keyboard_arrow_down,
                                        size: 18, color: Colors.grey.shade700),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Clear filter
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            selectedMonth = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Order List
          Expanded(
            child: StreamBuilder<List<QueryDocumentSnapshot>>(
              stream: getOrdersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No orders found'));
                }

                final orders = snapshot.data!;

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final orderData = order.data() as Map<String, dynamic>;
                    final orderId = order.id;
                    final uid = orderData['uid'] as String? ?? '';
                    final status = orderData['status'] as String? ?? '';
                    final timestamp = orderData['timestamp'] as Timestamp?;
                    final date = timestamp?.toDate();

                    return FutureBuilder<String>(
                      future: getSiswaName(uid),
                      builder: (context, siswaSnapshot) {
                        final siswaName = siswaSnapshot.data ?? 'Loading...';

                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: ExpansionTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Order from $siswaName'),
                                const SizedBox(height: 4),
                                Text(
                                  'Order ID: $orderId',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              date != null
                                  ? '${date.day}/${date.month}/${date.year}'
                                  : 'No date',
                            ),
                            children: [
                              FutureBuilder<List<Map<String, dynamic>>>(
                                future: getMenuItems(orderId),
                                builder: (context, menuSnapshot) {
                                  if (menuSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  if (menuSnapshot.hasError) {
                                    return Text('Error: ${menuSnapshot.error}');
                                  }
                                  if (!menuSnapshot.hasData ||
                                      menuSnapshot.data!.isEmpty) {
                                    return const Text('No menu items');
                                  }

                                  final menuItems = menuSnapshot.data!;
                                  return Column(
                                    children: [
                                      ...menuItems.map((item) {
                                        return ListTile(
                                          title: Text(item['nama_menu']?? ''),
                                          subtitle: Text(
                                              'Quantity: ${item['quantity'] ?? 0}'),
                                        );
                                      }).toList(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: status == 'selesai'
                                            ? const Text(
                                                'Pesanan sudah selesai',
                                                style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.grey,
                                                ),
                                              )
                                            : ElevatedButton(
                                                onPressed:
                                                    status == 'siap diambil'
                                                        ? null
                                                        : () {
                                                            updateOrderStatus(
                                                                orderId);
                                                          },
                                                child: const Text(
                                                    'Makanan siap diambil'),
                                              ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
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

  void _showMonthPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Select Month',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: months.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(months[index]),
                      onTap: () {
                        setState(() {
                          selectedMonth = months[index];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showYearPicker() {
    final int currentYear = DateTime.now().year;
    final List<int> years =
        List.generate(10, (index) => currentYear - 5 + index);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Select Year',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: years.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(years[index].toString()),
                      onTap: () {
                        setState(() {
                          selectedYear = years[index];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
