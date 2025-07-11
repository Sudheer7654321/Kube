import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mobile_recharge_pay_page.dart';
import 'recharge_plans.dart';

class MobileRechargePage extends StatefulWidget {
  final String name;
  final String number;

  const MobileRechargePage({
    super.key,
    required this.name,
    required this.number,
  });

  @override
  State<MobileRechargePage> createState() => _MobileRechargePageState();
}

class _MobileRechargePageState extends State<MobileRechargePage> {
  String operator = 'jio'; // Change manually if needed
  List<Map<String, String>> plans = [];
  List<Map<String, String>> filteredPlans = [];
  String circle = 'Andhra Pradesh & Telangana';

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPlans();
  }

  void loadPlans() {
    setState(() {
      plans = hardcodedPlans[operator.toLowerCase()] ?? [];
      filteredPlans = List.from(plans);
    });
  }

  void filterPlans(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      filteredPlans =
          plans.where((plan) {
            final desc = plan['desc']?.toLowerCase() ?? '';
            final validity = plan['validity']?.toLowerCase() ?? '';
            final amount = plan['amount']?.toLowerCase() ?? '';
            return desc.contains(lowerQuery) ||
                validity.contains(lowerQuery) ||
                amount.contains(lowerQuery);
          }).toList();
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const BackButton(color: Colors.white),
        title: Text(
          "Select a recharge plan",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.flash_on, color: Colors.orange),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Recharge your $operator number & get cashback',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.orange,
              child: Icon(Icons.sim_card, color: Colors.white),
            ),
            title: Text(
              widget.name,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              '${widget.number} • $operator',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500]),
            ),
            trailing: TextButton(
              onPressed: () {}, // Optional operator selector can go here
              child: Text(
                "Change",
                style: GoogleFonts.poppins(color: Color(0xFFB8D8C1)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: filterPlans,
              decoration: InputDecoration(
                hintText: "Search for a plan, eg 365 or 28 days",
                prefixIcon: const Icon(Icons.search),
                fillColor: Colors.grey.shade100,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: plans.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final p = plans[i];
                final amount = p['price'] ?? '0';
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  color: Colors.grey.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(
                      '₹$amount',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      '${p['validity'] ?? ''} • ${p['desc'] ?? ''}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    trailing: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.grey.shade500,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => MobileRechargePayPage(
                                  name: widget.name,
                                  number: widget.number,
                                  priceOfPlan: amount,
                                  descriptionOfPlan: p['desc'] ?? '',
                                  validityOfPlan: p['validity'] ?? '',
                                  operator: operator,
                                  circle: circle,
                                ),
                          ),
                        );
                      },
                      child: Text(
                        "Recharge",
                        style: GoogleFonts.poppins(color: Color(0xFFB8D8C1)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
