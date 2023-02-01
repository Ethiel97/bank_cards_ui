import 'dart:math';

import 'package:bank_cards_ui/data/card.dart';
import 'package:bank_cards_ui/state.dart';
import 'package:bank_cards_ui/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class BankCard extends StatefulWidget {
  final CardModel cardModel;
  final Function() onTap;

  const BankCard({
    Key? key,
    required this.cardModel,
    required this.onTap,
  }) : super(key: key);

  @override
  State<BankCard> createState() => _BankCardState();
}

class _BankCardState extends State<BankCard>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController animationController, secondAnimationController;
  late SequenceAnimation sequenceAnimation;
  late SequenceAnimation hideNotSelectedCardSequenceAnimation;

  late Animation rotateAnimation;

  @override
  void dispose() {
    animationController.dispose();
    secondAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));

    secondAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    rotateAnimation = Tween<double>(
      begin: -80 / 360,
      end: 0,
    ).animate(secondAnimationController);

    secondAnimationController.forward();

    secondAnimationController.addListener(() {
      setState(() {});
    });

    hideNotSelectedCardSequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            from: const Duration(milliseconds: 0),
            to: const Duration(milliseconds: 400),
            animatable: Tween<double>(
              begin: 1,
              end: 0,
            ),
            tag: 'hide')
        .animate(animationController);

    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            from: const Duration(milliseconds: 400),
            to: const Duration(milliseconds: 800),
            animatable: Tween<double>(
              begin: 1,
              end: .68,
            ),
            tag: 'scale')
        .addAnimatable(
            from: const Duration(milliseconds: 800),
            to: const Duration(milliseconds: 1200),
            animatable: Tween<double>(
              begin: 0,
              end: 90 / 360,
            ),
            tag: 'rotate')
        .
        /*.addAnimatable(
            from: const Duration(milliseconds: 800),
            to: const Duration(milliseconds: 1000),
            animatable: Tween<AlignmentGeometry>(
                begin: Alignment.center, end: Alignment.topCenter),
            tag: 'align')*/
        addAnimatable(
            from: const Duration(milliseconds: 1200),
            to: const Duration(milliseconds: 1400),
            animatable: Tween<Offset>(
              begin: const Offset(0, 0),
              end: const Offset(0, -.6),
            ),
            curve: Curves.easeIn,
            tag: 'slide')
        .addAnimatable(
            from: const Duration(milliseconds: 1400),
            to: const Duration(milliseconds: 1900),
            animatable: Tween<double>(
              begin: .9,
              end: 1,
            ),
            curve: Curves.elasticOut,
            tag: 'bouncing')
        .animate(animationController);

    animationController.addStatusListener((status) {
      // if (status == AnimationStatus.forward) handleCardAnimation();
      print("BANK CARD CLICKED STATUS: $status");
      setState(() {});
    });
  }

  handleCardAnimation() {
    if (animationController.isCompleted) {
      Provider.of<AppState>(context, listen: false).currentCard = null;
      animationController.reverse();
    } else {
      Provider.of<AppState>(context, listen: false).currentCard =
          widget.cardModel;

      print("CARD MODEL: ${widget.cardModel.balance}");
      animationController.forward();
    }
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: handleCardAnimation,
      child: Consumer<AppState>(
          builder: (context, appState, _) => AnimatedSlide(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
                offset: Offset(
                    appState.isViewingCardDetail
                        ? (appState.dragRatio / 1.2)
                        : 0,
                    0),
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return Transform(
                      transform: Matrix4.identity()..setEntry(3, 2, 0.008),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn,
                        opacity: (1 - appState.dragRatio),
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          scale: appState.isViewingCardDetail
                              ? (1 - appState.dragRatio) * 1.08
                              : 1,
                          child: ScaleTransition(
                            scale:
                                sequenceAnimation['scale'] as Animation<double>,
                            child: RotationTransition(
                              turns: sequenceAnimation['rotate']
                                  as Animation<double>,
                              child: SlideTransition(
                                position: sequenceAnimation['slide']
                                    as Animation<Offset>,
                                child: ScaleTransition(
                                  scale: sequenceAnimation['bouncing']
                                      as Animation<double>,
                                  child: Transform.translate(
                                    offset: const Offset(0, -65),
                                    child: child,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: card,
                ),
              )),
    );
  }

  Widget get card => Card(
        elevation: 12,
        shadowColor: Colors.black12.withOpacity(.002),
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.cardModel.colors,
                // begin: Alignment.topCenter,
                transform: const GradientRotation(1 / 16),
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(
                    .002,
                  ),
                  offset: const Offset(0, 15),
                  blurRadius: 30,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Credit card",
                        style: TextStyles.mainTextStyle
                            .apply(color: Colors.white, fontSizeDelta: 3),
                      ),
                    ),
                    Transform.rotate(
                      angle: pi * 90 / 180,
                      child: const Icon(
                        FontAwesomeIcons.wifi,
                        size: 28,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                const Spacer(),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    FontAwesomeIcons.microchip,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    FontAwesomeIcons.ccMastercard,
                    size: 28,
                    color: Colors.white,
                  ),
                )
              ],
            )),
      );

  @override
  bool get wantKeepAlive => true;
}
