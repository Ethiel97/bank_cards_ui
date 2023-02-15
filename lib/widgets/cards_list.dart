import 'package:bank_cards_ui/data/card.dart';
import 'package:bank_cards_ui/state.dart';
import 'package:bank_cards_ui/widgets/bank_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardsList extends StatefulWidget {
  const CardsList({
    super.key,
  });

  @override
  State<CardsList> createState() => _CardsListState();
}

class _CardsListState extends State<CardsList>
    with SingleTickerProviderStateMixin {
  CardModel tappedCard = cards.first;

  int currentPage = 0;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer<AppState>(
        builder: (context, appState, _) => PageView.builder(
          controller: appState.pageController,
          itemCount: cards.length,
          physics: !appState.isViewingCardDetail
              ? const BouncingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              if (kDebugMode) {
                print("CURRENT PAGE :$index");
              }
              currentPage = index;

              animationController.forward();
              if (currentPage == cards.length - 1) {
                animationController.forward();
              } else {
                animationController.reset();
              }
            });
          },
          itemBuilder: (context, i) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: RotatedBox(
              quarterTurns: 3,
              child: SizedBox(
                height: 290,
                width: MediaQuery.of(context).size.width * 1.2,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 400),
                  scale: cards.isSelectedCard(appState, i) ? 0 : 1,
                  child: AnimatedBuilder(
                    animation: animationController,
                    builder: (context, _) {
                      Animation animation = Tween(begin: 12.0, end: 0.0)
                          .animate(CurvedAnimation(
                              parent: animationController,
                              curve: Curves.easeInOut));

                      return buildCard(
                          index: i,
                          angle: (i == currentPage || i == currentPage - 1)
                              ? 0
                              : animation.value);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget buildCard({required int index, double angle = 0}) => Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, .001)
          ..rotateX(angle / 2)
          ..translate(angle / 4),
        child: BankCard(
          cardModel: cards[index],
        ),
      );
}
