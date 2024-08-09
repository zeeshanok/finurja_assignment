import 'package:finurja_assignment/models/bank_account.dart';
import 'package:finurja_assignment/utils.dart';
import 'package:flutter/material.dart';

class AccountTile extends StatelessWidget {
  const AccountTile({
    super.key,
    required this.account,
    required this.onTap,
    this.margin,
    this.padding,
  });
  final BankAccount account;
  final void Function() onTap;
  final EdgeInsetsGeometry? margin, padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ListTile(
        contentPadding: padding,
        leading: const Icon(Icons.attach_money),
        title: Text(account.name),
        subtitle: Text(account.accountNo),
        trailing: Text(
          currencyFormat(account.balance),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        titleTextStyle: Theme.of(context).textTheme.titleMedium,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
