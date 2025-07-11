import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hugeicons/hugeicons.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => ZoomDrawer.of(context)!.toggle(),
          icon: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Icon(
              HugeIcons.strokeRoundedMenuCollapse,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        title: Text(
          'Dashboard',
          style: GoogleFonts.poppins(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B2A49), Color(0xFF1B2A49)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total Net Worth',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹63,600',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    final colors = [
                      const Color(0xFFB8D8C1),
                      const Color(0xFFF8C8DC),
                      const Color(0xFFD9E4EC),
                      const Color(0xFFFFD6A5),
                    ];
                    final titles = ["Crypto", "Cards", "UPI", "Stocks"];
                    final values = ["₹42,150", "₹13,600", "₹7,850", "₹63,600"];
                    final icons = [
                      HugeIcons.strokeRoundedBitcoin01,
                      HugeIcons.strokeRoundedCreditCard,
                      HugeIcons.strokeRoundedWallet01,
                      HugeIcons.strokeRoundedChartBreakoutCircle,
                    ];

                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: colors[index],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  titles[index],
                                  style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    icons[index],
                                    size: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              values[index],
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Expanded(child: MiniLineChart()),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              // 🟡 Weekly Growth
              Text(
                'User in The Last Week',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 5),
              Text(
                '+2.1%',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 180, child: BarChartWidget()),

              const SizedBox(height: 30),

              // 🟠 Monthly Profits Donut Chart
              Text(
                'Monthly Profits',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              const DonutChartWidget(),

              const SizedBox(height: 30),

              // 🔵 Transactions Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transactions',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Analytics',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                children: const [
                  TransactionCard(
                    icon: Icons.account_circle,
                    bgColor: Colors.grey,
                    name: 'Sudheer',
                    time: '19 October 15:58',
                    amount: '+₹2351.00',
                    amountColor: Colors.greenAccent,
                    showIcon: true,
                  ),
                  TransactionCard(
                    icon: Icons.play_circle_fill,
                    bgColor: Colors.pinkAccent,
                    name: 'Youtube Music',
                    time: '21 October 19:20',
                    amount: '-₹5.50',
                    amountColor: Colors.redAccent,
                  ),
                  TransactionCard(
                    icon: Icons.person,
                    bgColor: Colors.grey,
                    name: 'Prasanna',
                    time: '02 Minutes Ago',
                    amount: '+₹61.00',
                    amountColor: Colors.greenAccent,
                  ),
                  TransactionCard(
                    icon: Icons.music_note,
                    bgColor: Colors.orange,
                    name: 'Spotify',
                    time: '14 September 12:25',
                    amount: '-₹3.50',
                    amountColor: Colors.redAccent,
                  ),
                  TransactionCard(
                    icon: Icons.payment,
                    bgColor: Colors.green,
                    name: 'Easy Pay',
                    time: '12 October 17:10',
                    amount: '+₹15.00',
                    amountColor: Colors.greenAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 📈 Bar Chart
class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    days[value.toInt()],
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barGroups: List.generate(7, (index) {
          final values = [15, 20, 37, 30, 10, 25, 30];
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: values[index].toDouble(),
                color: index == 2 ? Colors.pinkAccent : Colors.greenAccent,
                width: 14,
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// 📉 Mini Line Chart
class MiniLineChart extends StatelessWidget {
  const MiniLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots: const [
              FlSpot(0, 2),
              FlSpot(1, 2.5),
              FlSpot(2, 1.8),
              FlSpot(3, 3),
              FlSpot(4, 2.6),
            ],
            dotData: FlDotData(show: false),
            color: Colors.black,
            barWidth: 2,
          ),
        ],
      ),
    );
  }
}

// 🍩 Donut Chart
class DonutChartWidget extends StatefulWidget {
  const DonutChartWidget({super.key});

  @override
  State<DonutChartWidget> createState() => _DonutChartWidgetState();
}

class _DonutChartWidgetState extends State<DonutChartWidget> {
  int? touchedIndex;

  final List<Map<String, dynamic>> categories = [
    {'title': 'Stocks', 'value': 40000.0, 'color': Colors.greenAccent},
    {'title': 'Crypto', 'value': 30000.0, 'color': Colors.blueAccent},
    {'title': 'Cards', 'value': 20000.0, 'color': Colors.orangeAccent},
    {'title': 'UPI', 'value': 10000.0, 'color': Colors.pinkAccent},
  ];

  double get totalProfit =>
      categories.fold(0, (sum, item) => sum + item['value']);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              centerSpaceRadius: 60,
              sectionsSpace: 2,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        response == null ||
                        response.touchedSection == null) {
                      touchedIndex = null;
                    } else {
                      final index =
                          response.touchedSection!.touchedSectionIndex;
                      if (index >= 0 && index < categories.length) {
                        touchedIndex = index;
                      } else {
                        touchedIndex = null;
                      }
                    }
                  });
                },
              ),
              sections: List.generate(categories.length, (index) {
                final isTouched = touchedIndex == index;
                final category = categories[index];
                final double radius = isTouched ? 90 : 80;

                return PieChartSectionData(
                  color: category['color'],
                  value: category['value'],
                  title:
                      '${category['title']}\n₹${(category['value'] as double).toStringAsFixed(0)}',
                  titleStyle: GoogleFonts.poppins(
                    fontSize: isTouched ? 14 : 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  radius: radius,
                );
              }),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                touchedIndex != null &&
                        touchedIndex! >= 0 &&
                        touchedIndex! < categories.length
                    ? categories[touchedIndex!]['title']
                    : 'Total',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                touchedIndex != null &&
                        touchedIndex! >= 0 &&
                        touchedIndex! < categories.length
                    ? '₹${(categories[touchedIndex!]['value'] as double).toStringAsFixed(0)}'
                    : '₹${totalProfit.toStringAsFixed(0)}',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 💳 Transaction Card
class TransactionCard extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final String name;
  final String time;
  final String amount;
  final Color amountColor;
  final bool showIcon;

  const TransactionCard({
    super.key,
    required this.icon,
    required this.bgColor,
    required this.name,
    required this.time,
    required this.amount,
    required this.amountColor,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: bgColor,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                amount,
                style: GoogleFonts.poppins(
                  color: amountColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (showIcon)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.lock, color: Colors.white30, size: 18),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
