import 'dart:async';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:hugeicons/hugeicons.dart';
import 'package:kube/pages/stock/buyPages/buy_screen.dart';
import 'package:provider/provider.dart';
import 'wishlist/wishlist_model.dart';

class StockPoint {
  final DateTime time;
  final double price;

  StockPoint({required this.time, required this.price});
}

class StockDetailPage extends StatefulWidget {
  final String stockSymbol;
  final String companyName;
  final String logoUrl;
  const StockDetailPage({
    super.key,
    required this.stockSymbol,
    required this.companyName,
    required this.logoUrl,
  });

  @override
  State<StockDetailPage> createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  final List<String> durations = ['1d', '5d', '1mo', '1y', '5y', 'max'];
  final Map<String, String> intervalMap = {
    '1d': '1m',
    '5d': '5m',
    '1mo': '1d',
    '1y': '1wk',
    '5y': '1mo',
    'max': '1mo',
  };

  String marketCap = "Loading...";
  String revenue = "Loading...";
  String growthRate = "Loading...";

  String selectedRange = '1d';
  List<StockPoint> _data = [];

  double get minPrice =>
      _data.map((e) => e.price).reduce((a, b) => a < b ? a : b);
  double get maxPrice =>
      _data.map((e) => e.price).reduce((a, b) => a > b ? a : b);

  @override
  void initState() {
    super.initState();
    fetchStockData();
    fetchCompanyInfo();
  }

  Future<void> fetchStockData() async {
    final url = Uri.parse(
      "https://query1.finance.yahoo.com/v8/finance/chart/${widget.stockSymbol}?interval=${intervalMap[selectedRange]}&range=$selectedRange",
    );

    print("Fetching data from: $url");

    try {
      final response = await http.get(url);
      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      final Map<String, dynamic> jsonData = json.decode(response.body);

      // Check for valid data
      final result = jsonData['chart']['result'];
      if (result == null || result.isEmpty) {
        print('No chart data for ${widget.stockSymbol}');
        setState(() {
          _data = []; // Clear data so UI doesn't hang
        });
        return;
      }

      final timestamps = result[0]['timestamp'];
      final prices = result[0]['indicators']['quote'][0]['close'];

      final points = <StockPoint>[];
      for (int i = 0; i < timestamps.length; i++) {
        if (prices[i] != null) {
          final time = DateTime.fromMillisecondsSinceEpoch(
            timestamps[i] * 1000,
          );
          final price = prices[i].toDouble();
          points.add(StockPoint(time: time, price: price));
        }
      }

      setState(() => _data = points);
    } catch (e) {
      print("Error: $e");
      setState(() {
        _data = [];
      });
    }
  }

  Future<void> fetchCompanyInfo() async {
    final url = Uri.parse(
      'https://yh-finance.p.rapidapi.com/stock/v2/get-summary?symbol=${widget.stockSymbol}&region=US',
    );

    final response = await http.get(
      url,
      headers: {
        'X-RapidAPI-Key': 'c568a2ad37msh980740e3a57d9fap1e2a8ejsn52849c95dcfd',
        'X-RapidAPI-Host': 'yh-finance.p.rapidapi.com',
      },
    );

    final data = json.decode(response.body);

    setState(() {
      marketCap = data['price']['marketCap']?['fmt'] ?? 'N/A';
      revenue = data['financialData']['totalRevenue']?['fmt'] ?? 'N/A';
      growthRate = data['earningsTrend']['trend'][1]['growth']?['fmt'] ?? 'N/A';
    });
  }

  Widget buildChart() {
    final spots =
        _data
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), e.value.price))
            .toList();
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots: spots,
            color: Colors.green,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRangeBar() {
    final current = _data.last.price;
    final percent = (current - minPrice) / (maxPrice - minPrice);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "₹${minPrice.toStringAsFixed(2)}",
              style: GoogleFonts.poppins(fontSize: 12),
            ),
            Text(
              "₹${maxPrice.toStringAsFixed(2)}",
              style: GoogleFonts.poppins(fontSize: 12),
            ),
          ],
        ),
        Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: const LinearGradient(
                  colors: [Colors.cyanAccent, Color(0xFFB8D8C1)],
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * percent - 10,
              top: 0,
              child: const Icon(Icons.arrow_drop_down, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDurationSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          durations.map((d) {
            final sel = selectedRange == d;
            return GestureDetector(
              onTap: () {
                setState(() => selectedRange = d);
                fetchStockData();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: sel ? Colors.grey.shade300 : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Text(
                  d.toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget buildAnalystRatings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          "Analyst ratings: Buy",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 20,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Buy\n100%", style: GoogleFonts.poppins(color: Colors.green)),
            Text("Hold\n0%", style: GoogleFonts.poppins(color: Colors.orange)),
            Text("Sell\n0%", style: GoogleFonts.poppins(color: Colors.red)),
          ],
        ),
        SizedBox(height: 6),
        Text(
          "This analysis is based on the reviews of 12 experts in the last 7 days",
          style: GoogleFonts.poppins(fontSize: 12),
        ),
      ],
    );
  }

  Widget buildChecklistItem(String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color),
        SizedBox(height: 4),
        Text(label, style: GoogleFonts.poppins(fontSize: 12)),
      ],
    );
  }

  Widget buildInvestmentChecklist() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          "Investment checklist: (2/6)",
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            buildChecklistItem("Equity returns", Icons.close, Colors.red),
            buildChecklistItem("Dividend returns", Icons.check, Colors.green),
            buildChecklistItem("Safety factor", Icons.check, Colors.green),
            buildChecklistItem("Growth factor", Icons.help, Colors.grey),
            buildChecklistItem("Debt vs Equity", Icons.close, Colors.red),
            buildChecklistItem("Profit factor", Icons.help, Colors.grey),
          ],
        ),
        SizedBox(height: 6),
        Text(
          "The investment checklist helps you understand a company's financial health at a glance and identify quality investment opportunities easily.",
          style: GoogleFonts.poppins(fontSize: 12),
        ),
      ],
    );
  }

  Widget buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          "About",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          '${widget.companyName} is a U.S.-based publicly traded company engaged in delivering products and services across the __ sector. Headquartered in the United States, the company operates on a global scale and is recognized for its innovation, market leadership, and consistent financial performance. ${widget.companyName} is listed on the __ and is widely followed by institutional and retail investors. It plays a significant role in shaping industry trends and often features in major indices like the S&P 500 or NASDAQ-100.',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        SizedBox(height: 12),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Market Cap",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                Text(marketCap, style: GoogleFonts.poppins()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Revenue",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                Text(revenue, style: GoogleFonts.poppins()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Growth Rate",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                Text(growthRate, style: GoogleFonts.poppins()),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              final wishlist = Provider.of<WishListProvider>(
                context,
                listen: false,
              );
              final isWishList = wishlist.isInWishList(widget.stockSymbol);

              if (isWishList) {
                wishlist.removeFromWishList(widget.stockSymbol);
              } else {
                wishlist.addTOWishList(
                  WishListItem(
                    companyName: widget.companyName,
                    symbol: widget.stockSymbol,
                    logoURl: widget.logoUrl,
                    price: _data.last.price,
                  ),
                );
              }
            },
            icon: Consumer<WishListProvider>(
              builder: (context, wishlist, _) {
                final isWishList = wishlist.isInWishList(widget.stockSymbol);

                return Icon(
                  HugeIcons.strokeRoundedFavourite,
                  color: isWishList ? Colors.red : Colors.black,
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child:
            _data.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(widget.logoUrl),
                              radius: 24,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.companyName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    widget.stockSymbol,
                                    style: GoogleFonts.poppins(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "100% Buy",
                                style: GoogleFonts.poppins(
                                  color: Colors.green,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "₹${_data.last.price.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(fontSize: 32),
                        ),
                        Text(() {
                          final change = _data.last.price - _data.first.price;
                          final percent = (change / _data.first.price) * 100;
                          final sign = change >= 0 ? '+' : '-';
                          return "$sign₹${change.abs().toStringAsFixed(2)} (${sign}${percent.abs().toStringAsFixed(2)}%) Today";
                        }(), style: GoogleFonts.poppins(color: Colors.green)),
                        const SizedBox(height: 20),
                        SizedBox(height: 200, child: buildChart()),
                        const SizedBox(height: 16),
                        buildRangeBar(),
                        const SizedBox(height: 20),
                        buildDurationSelector(),
                        buildAnalystRatings(),
                        buildInvestmentChecklist(),
                        buildAboutSection(),
                      ],
                    ),
                  ),
                ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              border: Border(
                top: BorderSide(color: Colors.grey.shade300.withOpacity(0.4)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => BuyStockScreen(
                                symbol: widget.stockSymbol,
                                companyName: widget.companyName,
                                currentPrice: _data.last.price,
                                logoUrl: widget.logoUrl,
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.withOpacity(0.9),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Buy',
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Sell action for ${widget.stockSymbol}',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.9),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Sell',
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
