import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kube/pages/stock/stock_detail_screen.dart';

class StockSearchScreen extends StatefulWidget {
  @override
  _StockSearchScreenState createState() => _StockSearchScreenState();
}

class _StockSearchScreenState extends State<StockSearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredStocks = [];
  bool isLoading = false;
  final String apiKey = 'BwZNVHrZlyIaHNyVrTGD2iKgs9vReJxx';

  Future<void> fetchStocks(String query) async {
    if (query.length < 2) {
      setState(() {
        filteredStocks = [];
      });
      return;
    }

    final url =
        'https://financialmodelingprep.com/api/v3/search?query=$query&limit=10&exchange=NASDAQ&apikey=$apiKey';

    setState(() => isLoading = true);

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);

        List<Map<String, dynamic>> results = [];

        for (var item in data) {
          final symbol = item['symbol'];

          if (symbol.endsWith('X')) continue;

          final profileUrl =
              'https://financialmodelingprep.com/api/v3/profile/$symbol?apikey=$apiKey';

          final profileResponse = await http.get(Uri.parse(profileUrl));
          String logoUrl = '';

          if (profileResponse.statusCode == 200) {
            final profileData = json.decode(profileResponse.body);
            if (profileData is List && profileData.isNotEmpty) {
              final sector = profileData[0]['sector'];
              final price = profileData[0]['price'];
              final isStock =
                  sector != null && sector != 'N/A' && price != null;

              if (!isStock) continue;

              logoUrl = profileData[0]['image'] ?? '';
            }
          }

          results.add({
            'name': item['name'],
            'symbol': symbol,
            'logo': logoUrl,
          });
        }

        setState(() {
          filteredStocks = results;
        });
      } else {
        setState(() => filteredStocks = []);
      }
    } catch (e) {
      print('Error: $e');
      setState(() => filteredStocks = []);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search by stock or symbol (e.g., apple, tesla)',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                ),
                onChanged: fetchStocks,
              ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Expanded(
                    child:
                        filteredStocks.isEmpty
                            ? Center(
                              child: Text(
                                'No results found',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            )
                            : ListView.builder(
                              itemCount: filteredStocks.length,
                              itemBuilder: (context, index) {
                                final stock = filteredStocks[index];
                                return Card(
                                  color: Colors.grey[850],
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => StockDetailPage(
                                                stockSymbol: stock['symbol'],
                                                companyName: stock['name'],
                                                logoUrl: stock['logo'],
                                              ),
                                        ),
                                      );
                                    },
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius: 20,
                                        backgroundImage:
                                            stock['logo'].isNotEmpty
                                                ? NetworkImage(stock['logo'])
                                                : null,
                                        child:
                                            stock['logo'].isEmpty
                                                ? Icon(
                                                  Icons.business,
                                                  color: Colors.black,
                                                )
                                                : null,
                                        backgroundColor: Colors.white,
                                      ),
                                      title: Text(
                                        stock['name'],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        stock['symbol'],
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.trending_up,
                                        color: Colors.greenAccent,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
