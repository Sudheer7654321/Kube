import 'package:flutter/material.dart';
import 'package:kube/pages/stock/Orders_screen/order_data.dart';
import 'package:kube/pages/stock/Orders_screen/order_provider.dart';
import 'package:kube/pages/stock/Orders_screen/stock_orders_screen.dart';

import 'package:provider/provider.dart';

class PreviewOrderScreen extends StatelessWidget {
  final String symbol;
  final double amount;
  final double stockPrice;
  final double shares;
  final String orderType;
  final String companyName;
  final String logoUrl;
  final double? limitPrice;

  const PreviewOrderScreen({
    Key? key,
    required this.symbol,
    required this.amount,
    required this.stockPrice,
    required this.shares,
    required this.companyName,
    required this.logoUrl,
    required this.orderType,
    this.limitPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preview Order", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(logoUrl),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "$companyName ($symbol)",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),
            Text(
              "You are buying",
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              "${shares.toStringAsFixed(4)} shares of $symbol",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Divider(thickness: 1.5),
            SizedBox(height: 16),

            _buildRow("Order Type", orderType),
            _buildRow("Shares", shares.toStringAsFixed(2)),

            if (orderType == "Limit Order" && limitPrice != null)
              _buildRow("Limit Price", "\₹${limitPrice!.toStringAsFixed(2)}"),

            if (orderType != "Limit Order")
              _buildRow("Market Price", "\₹${stockPrice.toStringAsFixed(2)}"),

            _buildRow("Total Cost", "\₹${amount.toStringAsFixed(2)}"),

            Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final order = Order(
                    symbol: symbol,
                    companyName: companyName,
                    logoUrl: logoUrl,
                    shares: shares,
                    price:
                        orderType == "Limit Order"
                            ? limitPrice ?? stockPrice
                            : stockPrice,
                    total: amount,
                    orderType: orderType,
                    date: DateTime.now(),
                  );

                  Provider.of<OrderProvider>(
                    context,
                    listen: false,
                  ).addOrder(order);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => StockOrdersScreen()),
                    (route) => false,
                  );
                },

                icon: Icon(Icons.check_circle_outline, color: Colors.black),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    "Confirm Order",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),

            SizedBox(height: 12),
            Center(
              child: Text(
                "Tap to confirm your order",
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16, color: Colors.black87)),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
