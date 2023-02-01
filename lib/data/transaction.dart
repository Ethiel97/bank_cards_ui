import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Transaction {
  final String title;
  final String recipient;
  final double amount;
  final IconData iconData;
  final Color iconBackgroundColor;
  final TransactionType transactionType;

  Transaction({
    required this.title,
    required this.recipient,
    required this.amount,
    required this.iconData,
    required this.iconBackgroundColor,
    this.transactionType = TransactionType.credit,
  });
}

extension TransactionExt on Transaction {
  bool get isDebit => transactionType == TransactionType.debit;

  bool get isCredit => transactionType == TransactionType.credit;

  String get formattedAmount => isDebit ? "-" : "+" "$amount";
}

List<Transaction> transactions = [
  Transaction(
    title: 'Transfer into',
    recipient: 'Enya',
    amount: 20000,
    iconData: FontAwesomeIcons.arrowsTurnRight,
    iconBackgroundColor: const Color(0xffff4676),
  ),
  Transaction(
    title: 'Nike (Central Park)',
    recipient: 'Shoes',
    amount: 145.50,
    iconData: FontAwesomeIcons.bagShopping,
    iconBackgroundColor: const Color(0xfffec15a),
  ),
  Transaction(
    title: 'Apple Music',
    recipient: 'Food',
    amount: 0.55,
    iconData: FontAwesomeIcons.music,
    iconBackgroundColor: const Color(0xff46495e),
  ),
  Transaction(
    title: 'Transfer into',
    recipient: 'Enya',
    amount: 20000,
    iconData: FontAwesomeIcons.arrowRight,
    iconBackgroundColor: const Color(0xff1639ff),
  ),
  Transaction(
    title: 'Nike (Central Park)',
    recipient: 'Shoes',
    amount: 145.50,
    iconData: FontAwesomeIcons.bagShopping,
    iconBackgroundColor: const Color(0xfffec15a),
  ),
  Transaction(
    title: 'Apple Music',
    recipient: 'Food',
    amount: 0.55,
    iconData: FontAwesomeIcons.music,
    iconBackgroundColor: const Color(0xff46495e),
  ),
  Transaction(
    title: 'Transfer into',
    recipient: 'Enya',
    amount: 20000,
    iconData: FontAwesomeIcons.arrowRight,
    iconBackgroundColor: const Color(0xffff4676),
  ),
  Transaction(
    title: 'Nike (Central Park)',
    recipient: 'Shoes',
    amount: 145.50,
    iconData: FontAwesomeIcons.bagShopping,
    iconBackgroundColor: const Color(0xfffec15a),
  ),
  Transaction(
    title: 'Apple Music',
    recipient: 'Food',
    amount: 0.55,
    iconData: FontAwesomeIcons.music,
    iconBackgroundColor: const Color(0xff46495e),
  ),
];

enum TransactionType { debit, credit }
