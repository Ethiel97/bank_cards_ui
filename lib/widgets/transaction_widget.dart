import 'package:bank_cards_ui/data/transaction.dart';
import 'package:bank_cards_ui/utils/text_styles.dart';
import 'package:flutter/material.dart';

class TransactionWidget extends StatelessWidget {
  final Transaction transaction;

  const TransactionWidget({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: transaction.iconBackgroundColor,
              radius: 25,
              child: Icon(
                transaction.iconData,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 14,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: TextStyles.mainTextStyle.apply(
                      fontWeightDelta: 5,
                      fontSizeDelta: -2,
                    ),
                  ),
                  Text(
                    transaction.recipient,
                    style: TextStyles.mainTextStyle.apply(
                      fontSizeDelta: -5,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
            Text(
              transaction.formattedAmount,
              style: TextStyles.mainTextStyle.apply(
                fontSizeDelta: -1,
                fontWeightDelta: 5,
              ),
            ),
          ],
        ),
      );
}
