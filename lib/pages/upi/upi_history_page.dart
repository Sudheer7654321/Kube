import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class UpiHistoryPage extends StatelessWidget {
  const UpiHistoryPage({super.key});

  final List<Map<String, dynamic>> historyData = const [
    {
      "date": "Today",
      "transactions": [
        {
          "icon": HugeIcons.strokeRoundedArrowUp01,
          "title": "Paid to Ravi",
          "subtitle": "ravi@ybl",
          "amount": "- ₹250",
          "type": "sent",
        },
        {
          "icon": HugeIcons.strokeRoundedArrowDown01,
          "title": "Received from Dad",
          "subtitle": "dad@okaxis",
          "amount": "+ ₹1,000",
          "type": "received",
        },
      ],
    },
    {
      "date": "Yesterday",
      "transactions": [
        {
          "icon": HugeIcons.strokeRoundedClock01,
          "title": "Pending to Ramesh",
          "subtitle": "ramesh@upi",
          "amount": "₹500",
          "type": "pending",
        },
        {
          "icon": HugeIcons.strokeRoundedArrowUpRight01,
          "title": "Paid to Swiggy",
          "subtitle": "swiggy@ybl",
          "amount": "- ₹305",
          "type": "sent",
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF11121A),
      appBar: AppBar(
        backgroundColor: Color(0xFF11121A),
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              'History',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        itemCount: historyData.length,
        itemBuilder: (context, index) {
          final section = historyData[index];
          final transactions = section["transactions"] as List;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  section["date"],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 13),
              ...transactions.map((txn) => _transactionTile(txn)).toList(),
              const SizedBox(height: 18),
            ],
          );
        },
      ),
    );
  }

  Widget _transactionTile(Map<String, dynamic> txn) {
    Color color;
    if (txn["type"] == "sent") {
      color = Colors.redAccent;
    } else if (txn["type"] == "received") {
      color = Colors.green;
    } else {
      color = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(txn["icon"], color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn["title"],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  txn["subtitle"],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Color(0xFFB8D8C1),
                  ),
                ),
              ],
            ),
          ),
          Text(
            txn["amount"],
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color:
                  txn["type"] == "received"
                      ? Colors.green
                      : txn["type"] == "sent"
                      ? Colors.redAccent
                      : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
