import 'package:bank_cards_ui/data/card.dart';
import 'package:bank_cards_ui/state.dart';
import 'package:bank_cards_ui/widgets/bank_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardsList extends StatelessWidget {
  CardsList({
    super.key,
  });

  CardModel tappedCard = cards.first;

  @override
  Widget build(BuildContext context) => Consumer<AppState>(
        builder: (context, appState, _) => PageView.builder(
          controller: appState.pageController,
          itemCount: cards.length,
          physics: !appState.isViewingCardDetail
              ? const BouncingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          itemBuilder: (context, i) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: RotatedBox(
              quarterTurns: 3,
              child: SizedBox(
                height: 290,
                width: 540,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 400),
                  scale: cards.isSelectedCard(appState, i) ? 0 : 1,
                  child: BankCard(
                    cardModel: cards[i],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
