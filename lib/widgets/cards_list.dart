import 'package:bank_cards_ui/data/card.dart';
import 'package:bank_cards_ui/state.dart';
import 'package:bank_cards_ui/widgets/bank_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:provider/provider.dart';

class CardsList extends StatefulWidget {
  const CardsList({
    Key? key,
  }) : super(key: key);

  @override
  State<CardsList> createState() => _CardsListState();
}

class _CardsListState extends State<CardsList>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  late SequenceAnimation sequenceAnimation;

  late Animation<double> animation;
  CardModel tappedCard = cards.first;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            from: const Duration(milliseconds: 0),
            to: const Duration(milliseconds: 400),
            animatable: Tween<double>(
              begin: 1,
              end: 0,
            ),
            curve: Curves.fastOutSlowIn,
            tag: 'hide')
        .animate(animationController);
  }

  handleTap() {
    if (animationController.isCompleted) {
      animationController.reverse();
      setState(() {});
    } else {
      animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) => Consumer<AppState>(
        builder: (context, appState, _) => Stack(
          clipBehavior: Clip.none,
          children: [
            PageView.builder(
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
                    width: 520,
                    child: (appState.currentCard ?? cards.first) != cards[i]
                        ? ScaleTransition(
                            scale:
                                sequenceAnimation['hide'] as Animation<double>,
                            child: BankCard(
                              cardModel: cards[i],
                              onTap: handleTap,
                            ),
                          )
                        : BankCard(
                            cardModel: cards[i],
                            onTap: handleTap,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
