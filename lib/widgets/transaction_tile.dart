import 'package:finurja_assignment/models/transaction.dart';
import 'package:finurja_assignment/utils.dart';
import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction});
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == TransactionType.credit;
    return ListTile(
      dense: true,
      title: Text(
        transaction.transactionNo.toString(),
        style: const TextStyle(fontSize: 14, letterSpacing: -0.3),
      ),
      subtitle: Text(
        dateFormat(transaction.createdAt),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      leading: RotatedBox(
        quarterTurns: isCredit ? 1 : 0,
        child: Icon(
          Icons.arrow_outward,
          size: 18,
          color: isCredit ? Colors.green.shade400 : Colors.red.shade400,
        ),
      ),
      trailing:
          _TransactionAmount(isCredit: isCredit, amount: transaction.amount),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}

class _TransactionAmount extends StatelessWidget {
  const _TransactionAmount({
    required this.amount,
    required this.isCredit,
  });
  final bool isCredit;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final leading = isCredit ? "+" : "-";
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "$leading ",
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          TextSpan(
            text: currencyFormat(amount),
            style: const TextStyle(
              fontSize: 14,
              letterSpacing: -0.1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
