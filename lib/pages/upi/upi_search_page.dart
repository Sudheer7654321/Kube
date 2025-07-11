import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class UpiSearchPage extends StatefulWidget {
  const UpiSearchPage({super.key});

  @override
  State<UpiSearchPage> createState() => _UpiSearchPageState();
}

class _UpiSearchPageState extends State<UpiSearchPage> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  final List<String> popularSearches = const [
    'Mobile Recharge',
    'Electricity Bill',
    'FASTag',
    'Movie Tickets',
    'DTH',
    'Mutual Funds',
  ];

  final List<Map<String, dynamic>> categories = const [
    {'icon': HugeIcons.strokeRoundedPhoneCheck, 'label': 'Mobile Recharge'},
    {'icon': HugeIcons.strokeRoundedTv02, 'label': 'DTH'},
    {'icon': HugeIcons.strokeRoundedBulb, 'label': 'Electricity'},
    {'icon': HugeIcons.strokeRoundedHospital01, 'label': 'Hospitals'},
    {'icon': HugeIcons.strokeRoundedTrain01, 'label': 'Train Booking'},
    {'icon': HugeIcons.strokeRoundedCar01, 'label': 'FASTag'},
    {'icon': HugeIcons.strokeRoundedBank, 'label': 'Banking'},
    {'icon': HugeIcons.strokeRoundedBarChart, 'label': 'Investments'},
  ];

  @override
  Widget build(BuildContext context) {
    // Filtered results based on _query
    final filteredPopular =
        popularSearches
            .where((item) => item.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    final filteredCategories =
        categories
            .where(
              (item) =>
                  item['label'].toLowerCase().contains(_query.toLowerCase()),
            )
            .toList();

    return Scaffold(
      backgroundColor: Color(0xFF11121A),
      body: SafeArea(
        child: Column(
          children: [
            /// 🔍 Search AppBar
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 40),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Search",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 16, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Color(0xFF1F202A),
                        borderRadius: BorderRadius.circular(30),
                        /*boxShadow: [
                          BoxShadow(
                            blurRadius: 6,
                            color: Colors.black.withOpacity(0.05),
                          ),
                        ],*/
                      ),
                      child: TextField(
                        style: GoogleFonts.poppins(color: Colors.white),
                        controller: _controller,
                        onChanged: (value) {
                          setState(() {
                            _query = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search for services, people, etc......',
                          hintStyle: GoogleFonts.poppins(color: Colors.white),
                          border: InputBorder.none,
                          icon: Icon(
                            HugeIcons.strokeRoundedSearch01,
                            color: Colors.white,
                          ),
                          suffixIcon:
                              _query.isNotEmpty
                                  ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _controller.clear();
                                      setState(() => _query = '');
                                    },
                                  )
                                  : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔥 Popular Searches
                    if (_query.isEmpty || filteredPopular.isNotEmpty) ...[
                      Text(
                        "Popular Searches",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children:
                            filteredPopular.map((search) {
                              return Chip(
                                backgroundColor: Color(0xFFB8D8C1),
                                label: Text(
                                  search,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                side: BorderSide.none,
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],

                    /// 📂 Categories
                    if (_query.isEmpty || filteredCategories.isNotEmpty) ...[
                      Text(
                        "Browse Categories",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        itemCount: filteredCategories.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                        itemBuilder: (context, index) {
                          final item = filteredCategories[index];
                          return Column(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Color(0xFF1F202A),
                                child: Icon(item['icon'], color: Colors.white),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item['label'],
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          );
                        },
                      ),
                    ],

                    /// No Results
                    if (_query.isNotEmpty &&
                        filteredPopular.isEmpty &&
                        filteredCategories.isEmpty) ...[
                      const SizedBox(height: 50),
                      Center(
                        child: Text(
                          "No results found.",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
