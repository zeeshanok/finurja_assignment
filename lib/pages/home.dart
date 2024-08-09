import 'package:finurja_assignment/models/bank_account.dart';
import 'package:finurja_assignment/pages/account.dart';
import 'package:finurja_assignment/providers/data.dart';
import 'package:finurja_assignment/widgets/account_tile.dart';
import 'package:finurja_assignment/widgets/summary_tile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: const SafeArea(
        child: _MainList(),
      ),
    );
  }
}

class _MainList extends StatelessWidget {
  const _MainList();

  void _handleTap(BuildContext context, String accountNo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AccountPage(accountNo: accountNo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = GetIt.instance<DataProvider>();

    final aggregateBalance = data.aggregateBalance.watch(context);

    return data.bankAccounts.watch(context).map(
          data: (acs) {
            final accounts = acs.values.toList();
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SummaryTile(
                    margin: const EdgeInsets.all(14),
                    balance: aggregateBalance.value!,
                    accountCount: accounts.length,
                  ),
                ),
                const SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      "Your accounts",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                accounts.isNotEmpty
                    ? _AccountsList(
                        onPressed: (accountNo) =>
                            _handleTap(context, accountNo),
                        accounts: accounts,
                      )
                    : const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text("No accounts to show"),
                        ),
                      ),
              ],
            );
          },
          error: (e) => Center(child: Text(e.toString())),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }
}

class _AccountsList extends StatelessWidget {
  const _AccountsList({
    required this.accounts,
    required this.onPressed,
  });
  final List<BankAccount> accounts;
  final void Function(String accountNo) onPressed;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return AccountTile(
            account: accounts[index],
            margin: const EdgeInsets.symmetric(horizontal: 14),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            onTap: () => onPressed(accounts[index].accountNo),
          );
        },
        childCount: accounts.length,
      ),
    );
  }
}
