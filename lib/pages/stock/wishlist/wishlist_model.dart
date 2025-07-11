import 'package:flutter/material.dart';

class WishListItem {
  final String symbol;
  final String companyName;
  final String logoURl;
  final double price;

  WishListItem({
    required this.symbol,
    required this.companyName,
    required this.logoURl,
    required this.price,
  });
}

class WishListProvider extends ChangeNotifier {
  final List<WishListItem> _wishList = [];

  List<WishListItem> get items => _wishList;

  void addTOWishList(WishListItem item) {
    if (!_wishList.any((e) => e.symbol == item.symbol)) {
      _wishList.add(item);
      notifyListeners();
    }
  }

  void removeFromWishList(String symbol) {
    _wishList.removeWhere((item) => item.symbol == symbol);
    notifyListeners();
  }

  bool isInWishList(String symbol) {
    return _wishList.any((item) => item.symbol == symbol);
  }
}
