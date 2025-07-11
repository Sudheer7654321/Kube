import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:kube/pages/stock/Orders_screen/stock_orders_screen.dart';
import 'package:kube/pages/stock/stock_home_screen.dart';
import 'package:kube/pages/stock/stock_search_screen.dart';
import 'package:kube/pages/stock/wishlist/stock_wishList_screen.dart';

class StockNavigationBar extends StatefulWidget {
  const StockNavigationBar({super.key});

  @override
  State<StockNavigationBar> createState() => _StockNavigationBarState();
}

class _StockNavigationBarState extends State<StockNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _stockNavBarPages = [
    StockPage(),
    StockSearchScreen(),
    StockOrdersScreen(),
    StockWishListScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (_selectedIndex != index) {
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(index: _selectedIndex, children: _stockNavBarPages),
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
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedChart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedFavourite),
            label: 'WishList',
          ),
        ],
      ),
    );
  }
}
