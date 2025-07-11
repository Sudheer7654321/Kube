import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:kube/pages/upi/RechargeAndSubs/Subscriptions/list_of_subs.dart';
import 'package:kube/pages/upi/RechargeAndSubs/Subscriptions/subscription_plans_page.dart';
// Make sure this import is correct

class SubscriptionFirstPage extends StatefulWidget {
  const SubscriptionFirstPage({super.key});

  @override
  State<SubscriptionFirstPage> createState() => _SubscriptionFirstPageState();
}

class _SubscriptionFirstPageState extends State<SubscriptionFirstPage> {
  String selectedCategory = '';
  String searchQuery = '';

  List<Map<String, dynamic>> get currentProviders {
    List<Map<String, dynamic>> baseList =
        selectedCategory.isEmpty
            ? providersByCategory.values.expand((e) => e).toList()
            : providersByCategory[selectedCategory] ?? [];

    if (searchQuery.isEmpty) return baseList;

    return baseList
        .where(
          (provider) => provider["name"].toString().toLowerCase().contains(
            searchQuery.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const BackButton(color: Colors.white),
        title: Text(
          "Select Provider",
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
        ),
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
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFB8D8C1),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFB8D8C1).withOpacity(0.4),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage("assets/images/avatar_male.jpg"),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Get up to ₹50 Cashback* on Subscriptions",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFFB8D8C1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Subscribe",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search Provider",
                hintStyle: GoogleFonts.poppins(color: Colors.white70),
                prefixIcon: const Icon(
                  HugeIcons.strokeRoundedSearch01,
                  color: Colors.white70,
                ),
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (_) => buildCategoryBottomSheet(),
                    );
                  },
                  icon: const Icon(
                    Icons.filter_alt_outlined,
                    color: Color(0xFFB8D8C1),
                  ),
                  label: Text(
                    "Filter",
                    style: GoogleFonts.poppins(color: Color(0xFFB8D8C1)),
                  ),
                ),
                const Spacer(),
                if (selectedCategory.isNotEmpty)
                  TextButton(
                    onPressed: () => setState(() => selectedCategory = ''),
                    child: Text(
                      "CLEAR",
                      style: GoogleFonts.poppins(color: Color(0xFFB8D8C1)),
                    ),
                  ),
              ],
            ),
          ),
          if (selectedCategory.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFB8D8C1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  selectedCategory,
                  style: GoogleFonts.poppins(color: Color(0xFFB8D8C1)),
                ),
              ),
            ),
          const SizedBox(height: 10),
          Expanded(
            child:
                currentProviders.isEmpty
                    ? Center(
                      child: Text(
                        "No providers found",
                        style: GoogleFonts.poppins(color: Colors.white70),
                      ),
                    )
                    : ListView.builder(
                      itemCount: currentProviders.length,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder: (_, index) {
                        final provider = currentProviders[index];
                        return Card(
                          color: Colors.grey.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(provider["image"]),
                            ),
                            title: Text(
                              provider["name"],
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              "Get up to ${provider["cashback"]} Cashback*",
                              style: GoogleFonts.poppins(
                                color: Color(0xFFB8D8C1),
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.deepPurple,
                              size: 16,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => SubscriptionPlansPage(
                                        provider: provider,
                                      ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                "Filter by category",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...categories.map(
            (cat) => RadioListTile(
              title: Text(cat, style: GoogleFonts.poppins(color: Colors.white)),
              value: cat,
              activeColor: Color(0xFFB8D8C1),
              groupValue: selectedCategory,
              onChanged: (val) {
                setState(() => selectedCategory = val.toString());
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
