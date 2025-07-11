import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'package:hugeicons/hugeicons.dart';
import 'package:kube/pages/stock/stock_data.dart';
import 'package:kube/pages/stock/stock_detail_screen.dart';

class Stock {
  final String symbol, category, name, changePercent, price, logoUrl;
  final Color changeColor;
  final double rawChange;

  Stock({
    required this.symbol,
    required this.category,
    required this.name,
    required this.changePercent,
    required this.price,
    required this.changeColor,
    required this.logoUrl,
    required this.rawChange,
  });
}

class StockPage extends StatefulWidget {
  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final List<String> months = ["1D", "5D", "1M", "6M", "YTD", "1Y"];
  final apiKey = "d19t751r01qmm7u1a77gd19t751r01qmm7u1a780";
  Timer? _timer;

  List<Stock> upTrend = [],
      gainers = [],
      losers = [],
      mostBought = [],
      topGainers = [],
      beginners = [];
  bool showMostBought = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(refreshAll);
    _timer = Timer.periodic(Duration(seconds: 30), (_) => refreshAll());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> refreshAll() async {
    upTrend.clear();
    gainers.clear();
    losers.clear();
    mostBought.clear();
    topGainers.clear();
    beginners.clear();

    final dataMap = await fetchAllCategoryData(categorySymbols, apiKey);
    upTrend.addAll(dataMap['UpTrend']!);
    gainers.addAll(dataMap["Today's Gainers"]!);
    losers.addAll(dataMap["Today's Losers"]!);
    mostBought.addAll(dataMap['Most Bought']!);
    topGainers.addAll(dataMap['Top Gainers']!);
    beginners.addAll(dataMap['Best For Beginners']!);

    setState(() {});
  }

  Future<Map<String, List<Stock>>> fetchAllCategoryData(
    Map<String, List<String>> categorySymbols,
    String token,
  ) async {
    Map<String, List<Stock>> result = {
      'UpTrend': [],
      "Today's Gainers": [],
      "Today's Losers": [],
      'Most Bought': [],
      'Top Gainers': [],
      'Best For Beginners': [],
    };

    for (final entry in categorySymbols.entries) {
      for (final sym in entry.value) {
        try {
          final qRes = await http.get(
            Uri.parse(
              'https://finnhub.io/api/v1/quote?symbol=$sym&token=$token',
            ),
          );
          final pRes = await http.get(
            Uri.parse(
              'https://finnhub.io/api/v1/stock/profile2?symbol=$sym&token=$token',
            ),
          );

          if (qRes.statusCode == 200 && pRes.statusCode == 200) {
            final q = json.decode(qRes.body);
            final p = json.decode(pRes.body);

            final curr = (q['c'] ?? 0).toDouble();
            final prev = (q['pc'] ?? 0).toDouble();
            final dp = prev != 0 ? ((curr - prev) / prev * 100) : 0;

            final stock = Stock(
              symbol: sym,
              category: entry.key,
              name: p['name'] ?? sym,
              price: "₹${curr.toStringAsFixed(2)}",
              changePercent: "${dp.toStringAsFixed(2)}%",
              changeColor: dp >= 0 ? Colors.green : Colors.red,
              logoUrl: p['logo'] ?? '',
              rawChange: dp,
            );

            result[entry.key]!.add(stock);
          }
        } catch (e) {
          print('Fetch error for ${entry.key}/$sym: $e');
        }
      }
    }

    result.forEach((key, value) {
      value.sort((a, b) => b.rawChange.compareTo(a.rawChange));
      if (value.length > 10) value.removeRange(10, value.length);
    });

    return result;
  }

  Widget stockListTile(Stock s) => InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => StockDetailPage(
                stockSymbol: s.symbol,
                companyName: s.name,
                logoUrl: s.logoUrl,
              ),
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundImage:
              s.logoUrl.isNotEmpty ? NetworkImage(s.logoUrl) : null,
          backgroundColor: Colors.grey.shade200,
          child:
              s.logoUrl.isEmpty
                  ? Text(
                    s.name[0],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                  : null,
        ),
        title: Text(
          s.name,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          s.price,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              s.rawChange >= 0 ? Icons.trending_up : Icons.trending_down,
              color: s.changeColor,
              size: 18,
            ),
            Text(
              s.changePercent,
              style: GoogleFonts.poppins(
                color: s.changeColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget stockTile(Stock s) => Container(
    width: 160,
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => StockDetailPage(
                  stockSymbol: s.symbol,
                  companyName: s.name,
                  logoUrl: s.logoUrl,
                ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: EdgeInsets.symmetric(vertical: 6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage:
                    s.logoUrl.isNotEmpty ? NetworkImage(s.logoUrl) : null,
                backgroundColor: Colors.grey.shade200,
                child:
                    s.logoUrl.isEmpty
                        ? Text(
                          s.name[0],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                        : null,
              ),
              SizedBox(height: 10),
              Text(
                s.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 4),
              Text(
                s.price,
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    s.rawChange >= 0 ? Icons.trending_up : Icons.trending_down,
                    color: s.changeColor,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    s.changePercent,
                    style: GoogleFonts.poppins(
                      color: s.changeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget sectionUI(List<Stock> list, {bool horizontal = true}) {
    if (list.isEmpty) {
      return SizedBox(
        height: 60,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return horizontal
        ? SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            itemBuilder:
                (_, i) => Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: stockTile(list[i]),
                ),
          ),
        )
        : Column(children: list.map(stockTile).toList());
  }

  Widget sectionWithHeader(
    String title,
    String subtitle,
    List<Stock> data, {
    bool horizontal = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 13),
        ),
        SizedBox(height: 12),
        sectionUI(data, horizontal: horizontal),
        SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      ZoomDrawer.of(context)!.toggle();
                    },
                    icon: Icon(HugeIcons.strokeRoundedMenuCollapse),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi Sudheer",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      //Spacer(),
                      Text(
                        "Invest smartly with less risk",
                        style: GoogleFonts.poppins(
                          color: Colors.grey[100],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.settings, color: Colors.grey[600]),
                ],
              ),
              SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "₹4.00",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "+₹0.00 (+0.00%)",
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 120,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              color: Colors.deepPurple,
                              barWidth: 3,
                              spots: [
                                FlSpot(0, 1),
                                FlSpot(1, 1.2),
                                FlSpot(2, 1.5),
                                FlSpot(3, 2),
                                FlSpot(4, 1.7),
                                FlSpot(5, 2.3),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:
                          months
                              .map(
                                (m) => Text(
                                  m,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: valueCard(
                      "Today's Return",
                      "+₹1.00",
                      Colors.orangeAccent.shade100,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: valueCard(
                      "Total Return",
                      "+₹3.00",
                      Colors.deepPurple.shade100,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              sectionWithHeader("UpTrend", "Top companies", upTrend),
              sectionWithHeader(
                "Today's Gainers",
                "Biggest % change today",
                gainers,
              ),
              sectionWithHeader(
                "Today's Losers",
                "Largest % drop today",
                losers,
              ),
              Text(
                "Browse Choices",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  ChoiceChip(
                    label: Text("Most Bought"),
                    selected: showMostBought,
                    onSelected: (_) => setState(() => showMostBought = true),
                  ),
                  SizedBox(width: 8),
                  ChoiceChip(
                    label: Text("Top Gainers"),
                    selected: !showMostBought,
                    onSelected: (_) => setState(() => showMostBought = false),
                  ),
                ],
              ),
              SizedBox(height: 12),
              if (showMostBought)
                ...mostBought.map(stockListTile).toList()
              else
                ...topGainers.map(stockListTile).toList(),
              SizedBox(height: 24),
              sectionWithHeader(
                "Best for Beginners",
                "Stable choices",
                beginners,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget valueCard(String label, String value, Color bg) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 14)),
          SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
