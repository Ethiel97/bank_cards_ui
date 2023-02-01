import 'package:bank_cards_ui/data/card.dart';
import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  CardModel? _currentCard;

  PageController pageController = PageController(viewportFraction: .8);

  double _transactionSheetDragRatio = .0;

  DraggableScrollableController scrollableController =
      DraggableScrollableController();

  CardModel? get currentCard => _currentCard;

  set currentCard(CardModel? currentCard) {
    scrollToCard();
    _currentCard = currentCard;
    notifyListeners();
  }

  double get dragRatio => _transactionSheetDragRatio;

  set dragRatio(val) {
    _transactionSheetDragRatio = val;
    notifyListeners();
  }

  scrollToCard() {
    if (currentCard != null) {
      pageController.animateToPage(cards.indexOf(currentCard!),
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  bool get isViewingCardDetail => _currentCard != null;
}
