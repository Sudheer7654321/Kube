import 'package:flutter/material.dart';
import 'package:kube/pages/cards/card.dart';

class AppState with ChangeNotifier {
  CardModel? _currentCard;

  PageController pageController = PageController(viewportFraction: 1.0);

  double _transactionSheetDragRatio = .0;

  DraggableScrollableController scrollableController =
      DraggableScrollableController();

  CardModel? get currentCard => _currentCard;

  set currentCard(CardModel? currentCard) {
    _currentCard = currentCard;
    scrollToCard();
    notifyListeners();
  }

  double get dragRatio => _transactionSheetDragRatio;

  set dragRatio(val) {
    _transactionSheetDragRatio = val;
    notifyListeners();
  }

  void scrollToCard() {
    if (currentCard != null && pageController.hasClients) {
      pageController.animateToPage(
        cards.indexOf(currentCard!),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  bool get isViewingCardDetail => _currentCard != null;
}
