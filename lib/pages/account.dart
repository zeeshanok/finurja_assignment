import 'package:finurja_assignment/models/transaction.dart';
import 'package:finurja_assignment/providers/data.dart';
import 'package:finurja_assignment/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key, required this.accountNo});

  final String accountNo;

  @override
  Widget build(BuildContext context) {
    final bankAccounts = GetIt.instance<DataProvider>().bankAccounts;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text("Account"),
        centerTitle: true,
      ),
      body: bankAccounts.watch(context).map(
            data: (accounts) {
              final transactions = accounts[accountNo]!.transactions;

              return _TransactionList(
                transactions: transactions,
                onScrollEndReached: () {
                  debugPrint("the end");
                },
              );
            },
            error: () => const Placeholder(),
            loading: () => const CircularProgressIndicator(),
          ),
    );
  }
}

class _TransactionList extends StatefulWidget {
  const _TransactionList({
    required this.transactions,
    required this.onScrollEndReached,
  });

  final List<Transaction> transactions;
  final void Function() onScrollEndReached;

  @override
  State<_TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<_TransactionList> {
  final _controller = ScrollController();

  bool get _isAtEnd =>
      _controller.position.pixels == _controller.position.maxScrollExtent;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_isAtEnd) widget.onScrollEndReached();

      _controller.addListener(() {
        if (_isAtEnd) widget.onScrollEndReached();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: ListView.builder(
        controller: _controller,
        itemCount: widget.transactions.length,
        itemBuilder: (context, index) {
          final t = widget.transactions[index];
          final isCredit = t.type == TransactionType.credit;
          return ListTile(
            title: Text(
              t.transactionNo.toString(),
              style: const TextStyle(fontSize: 14, letterSpacing: -0.3),
            ),
            subtitle: Text(
              dateFormat(t.createdAt),
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
            trailing: _TransactionAmount(isCredit: isCredit, amount: t.amount),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          )
        ],
      ),
    );
  }
}
