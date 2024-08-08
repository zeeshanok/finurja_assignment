import 'package:finurja_assignment/models/bank_account.dart';
import 'package:finurja_assignment/utils.dart';
import 'package:flutter/material.dart';

class AccountTile extends StatelessWidget {
  const AccountTile({super.key, required this.account, required this.onTap});
  final BankAccount account;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
    );
  }
}
