import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kube/pages/stock/stock_detail_screen.dart';
import 'package:provider/provider.dart';
import 'wishlist_model.dart';

class StockWishListScreen extends StatelessWidget {
  const StockWishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishList = Provider.of<WishListProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("WishList Screen", style: TextStyle(color: Colors.white)),
      ),
      body:
          wishList.items.isEmpty
              ? Center(
                child: Text(
                  "No items in WishList",
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
              )
              : ListView.builder(
                itemCount: wishList.items.length,
                itemBuilder: (context, index) {
                  final item = wishList.items[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => StockDetailPage(
                                stockSymbol: item.symbol,
                                companyName: item.companyName,
                                logoUrl: item.logoURl,
                              ),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(item.logoURl),
                      ),
                      title: Text(
                        item.companyName,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        item.symbol,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item.price > 0
                                ? Icons.trending_up
                                : Icons.trending_down,
                            color: item.price > 0 ? Colors.green : Colors.red,
                          ),
                          Text(
                            item.price.toStringAsFixed(2),
                            style: GoogleFonts.poppins(
                              color: item.price > 0 ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
