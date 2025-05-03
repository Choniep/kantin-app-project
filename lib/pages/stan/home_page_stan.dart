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
      setState(() {
        isLoading = false;
      });
      return;
    }
    final uid = user.uid;
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year + 1, 1, 1);

    try {
      QuerySnapshot ordersSnapshot = await _firestore
          .collection('orders')
          .where('stan_id', isEqualTo: uid)
          .get();

      Map<int, double> monthlySales = {
        for (var i = 1; i <= 12; i++) i: 0.0,
      };

      for (var doc in ordersSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final timestamp = data['timestamp'] as Timestamp?;
        final status = data['status'];
        final totalPrice = (data['totalPrice'] ?? 0).toDouble();

        if (timestamp != null &&
            status == 'Selesai' &&
            timestamp.toDate().isAfter(startOfYear) &&
            timestamp.toDate().isBefore(endOfYear)) {
          final month = timestamp.toDate().month;
          monthlySales[month] = (monthlySales[month] ?? 0) + totalPrice;
        }
      }

      setState(() {
        salesPerMonth = monthlySales;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching sales data: $e');
    }
  }

  List<FlSpot> getLineSpots() {
    return List.generate(6, (i) {
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
                    const Text('Last 6 months'),
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
                                showTitles: true,
                                reservedSize: 40,
                                interval: 10000,
                                getTitlesWidget: (value, meta) {
                                  return Text('${value ~/ 1000}K');
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
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
