import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'order_provider.dart';

class StockOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context).orders.reversed.toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "My Orders",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body:
          orders.isEmpty
              ? Center(
                child: Text(
                  "No orders yet",
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
              )
              : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Card(
                    margin: EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(order.logoUrl),
                        radius: 24,
                      ),
                      title: Text("${order.companyName} (${order.symbol})"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Shares: ${order.shares.toStringAsFixed(4)}"),
                          Text("Price: ₹${order.price.toStringAsFixed(2)}"),
                          Text("Total: ₹${order.total.toStringAsFixed(2)}"),
                          Text("Order Type: ${order.orderType}"),
                          Text("Date: ${order.date.toLocal()}".split('.')[0]),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
