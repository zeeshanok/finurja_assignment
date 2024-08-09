import 'package:finurja_assignment/models/bank_account.dart';
import 'package:finurja_assignment/utils.dart';
import 'package:finurja_assignment/widgets/colored_tile.dart';
import 'package:flutter/material.dart';

class AccountSummary extends StatelessWidget {
  const AccountSummary({super.key, required this.account, this.margin});

  final BankAccount account;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return ColoredTile(
      margin: margin,
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            textBaseline: TextBaseline.alphabetic,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(
                account.name,
                style: const TextStyle(fontSize: 22),
              ),
              Text(
                account.accountNo,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text.rich(TextSpan(
            text: "Balance: ",
            children: [
              TextSpan(
                text: currencyFormat(account.balance),
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              )
            ],
          )),
          // Text()
        ],
      ),
    );
  }
}
