import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePageStan extends StatefulWidget {
  const HomePageStan({super.key});

  @override
  State<HomePageStan> createState() => _HomePageStanState();
}

class _HomePageStanState extends State<HomePageStan> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<int, double> salesPerMonth = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSalesData();
  }

  Future<void> fetchSalesData() async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint('No authenticated user found.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    final uid = user.uid;
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year + 1, 1, 1);

    debugPrint('Fetching orders for UID: $uid from $startOfYear to $endOfYear');

    try {
      final query = _firestore
          .collection('orders')
          .where('stanId', isEqualTo: uid)
          .where('status', isEqualTo: 'selesai');

      debugPrint('Running Firestore query...');

      QuerySnapshot ordersSnapshot = await query.get();

      debugPrint('Fetched ${ordersSnapshot.docs.length} documents.');

      Map<int, double> monthlySales = {
        for (var i = 1; i <= 12; i++) i: 0.0,
      };

      for (var doc in ordersSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final timestamp = data['timestamp'];
        final totalPrice = (data['totalPrice'] ?? 0).toDouble();
        final status = data['status'];
        final stanId = data['stanId'];

        debugPrint(
            'Order -> timestamp: $timestamp, status: $status, stanId: $stanId, totalPrice: $totalPrice');

        if (timestamp is Timestamp) {
          DateTime date = timestamp.toDate();
          if (date.isAfter(startOfYear) && date.isBefore(endOfYear)) {
            int month = date.month;
            debugPrint('Adding $totalPrice to month $month');
            monthlySales[month] = (monthlySales[month] ?? 0) + totalPrice;
          } else {
            debugPrint('Skipping order - date $date not in range');
          }
        } else {
          debugPrint('Invalid timestamp format: $timestamp');
        }
      }

      setState(() {
        salesPerMonth = monthlySales;
        isLoading = false;
      });

      debugPrint('Monthly sales: $monthlySales');
    } catch (e) {
      debugPrint('Error fetching sales data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<FlSpot> getLineSpots() {
    return List.generate(12, (i) {
      double value = salesPerMonth[i + 1] ?? 0.0;
      return FlSpot(i.toDouble(), value);
    });
  }

  final monthNames = {
    1: 'January',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stand Performance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              fetchSalesData();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Income Trends',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Text('Last 12 months'),
                    const SizedBox(height: 12),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: LineChart(
                        LineChartData(
                          minY: 0,
                          maxY: (salesPerMonth.values.isEmpty
                                  ? 0
                                  : salesPerMonth.values
                                      .reduce((a, b) => a > b ? a : b)) *
                              1.2,
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              spots: getLineSpots(),
                              dotData: FlDotData(show: true),
                              barWidth: 3,
                              color: Colors.deepPurple,
                            )
                          ],
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles:
                                    false, // Set to false to remove Y-axis labels
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const months = [
                                    'Jan',
                                    'Feb',
                                    'Mar',
                                    'Apr',
                                    'May',
                                    'Jun',
                                    'Jul',
                                    'Aug',
                                    'Sep',
                                    'Oct',
                                    'Nov',
                                    'Dec'
                                  ];
                                  if (value.toInt() >= 0 &&
                                      value.toInt() < months.length) {
                                    return Text(months[value.toInt()]);
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: true),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Details',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...monthNames.entries.map(
                            (entry) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    entry.value,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    salesPerMonth[entry.key]
                                            ?.toStringAsFixed(0) ??
                                        '0',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
