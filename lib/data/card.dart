import 'dart:ui';

import 'package:bank_cards_ui/utils/colors.dart';

class CardModel {
  final double balance;

  final List<Color> colors;

  CardModel(
    this.balance,
    this.colors,
  );
}

List<CardModel> cards = [
  CardModel(9023, AppColors.gradientColors.first),
  CardModel(823, AppColors.gradientColors[1]),
  CardModel(1250, AppColors.gradientColors.last),
];

class Transaction {}
