import 'package:finurja_assignment/utils.dart';
import 'package:finurja_assignment/widgets/colored_tile.dart';
import 'package:flutter/material.dart';

class SummaryTile extends StatelessWidget {
  const SummaryTile({
    super.key,
    required this.balance,
    required this.accountCount,
    this.margin,
  });

  final int accountCount;
  final double balance;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return ColoredTile(
      margin: margin,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: SelectionArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Total Balance",
              style: TextStyle(fontSize: 18),
            ),
            Row(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  currencyFormat(balance),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  'across $accountCount accounts',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
