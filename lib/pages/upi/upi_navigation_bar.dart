import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'upi_history_page.dart';
import 'upi_home_page.dart';
import 'upi_profile_page.dart';
import 'upi_scanner_page.dart';
import 'upi_search_page.dart';

class UpiNavigationBar extends StatefulWidget {
  const UpiNavigationBar({super.key});

  @override
  State<UpiNavigationBar> createState() => _UpiNavigationBarState();
}

class _UpiNavigationBarState extends State<UpiNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _upiNavBarPages = [
    UpiHomePage(),
    UpiSearchPage(),
    // UpiScannerPage(),
    SizedBox(), // PlaceHolder For Scanner
    UpiHistoryPage(),
    UpiProfilePage(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UpiScannerPage()),
      );
      return; // do NOT change _selectedIndex
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(index: _selectedIndex, children: _upiNavBarPages),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFFB8D8C1),
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedHome01),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedSearch01),
            label: 'Search',
          ),
          // BottomNavigationBarItem(icon: Icon(Icons.qr_code_2), label: 'Scan'),
          BottomNavigationBarItem(
            /*icon: SvgPicture.asset(
              "assets/svgs/scanner_navbar_icon.svg",
              height: 54,
              width: 54,
              theme: SvgTheme(currentColor: Colors.white),
              // color: Colors.white,
            ),
            */
            icon: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(FontAwesomeIcons.qrcode),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedTime03),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedProfile02),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
