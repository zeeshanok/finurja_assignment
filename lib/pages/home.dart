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
    return const Scaffold(
      body: SafeArea(
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
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: AccountTile(
                          account: accounts[index],
                          onTap: () =>
                              _handleTap(context, accounts[index].accountNo),
                        ),
                      );
                    },
                    childCount: accounts.length,
                  ),
                ),
              ],
            );
          },
          error: (e) => Text(e.toString()),
          loading: () => const CircularProgressIndicator(),
        );
  }
}
