import 'dart:convert';

import 'package:finurja_assignment/models/bank_account.dart';
import 'package:finurja_assignment/models/transaction.dart';
import 'package:finurja_assignment/providers/data.dart';
import 'package:signals/signals.dart';

import 'package:flutter/services.dart' show rootBundle;

class JsonDataProvider implements DataProvider {
  final String _jsonPath;

  final Map<String, Signal<TransactionFilter>> _filterMap = {};

  final Map<String, ReadonlySignal<List<Transaction>>> _transactionsMap = {};

  JsonDataProvider(this._jsonPath);

  late final FutureSignal<Map<String, dynamic>> _rawData = computedAsync(
    () async {
      return jsonDecode(await rootBundle.loadString(_jsonPath))
          as Map<String, dynamic>;
    },
  );

  @override
  late final FutureSignal<double> aggregateBalance = computedAsync(
    () async {
      final data = await _rawData.future;
      return (data['aggregateBalance'] as num).toDouble();
    },
  );

  @override
  late final FutureSignal<Map<String, BankAccount>> bankAccounts =
      computedAsync(
    () async {
      final data = await _rawData.future;
      final accounts = (data['bankAccounts'] as Map<String, dynamic>);

      return {
        for (final acc in accounts.entries)
          acc.key: BankAccount.fromJson(acc.value)
      };
    },
  );

  @override
  ReadonlySignal<List<Transaction>> getTransactions(String bankAccount) {
    return _transactionsMap.putIfAbsent(
      bankAccount,
      () => computed(() {
        final t = _rawData().value?['transactions'][bankAccount];
        if (t != null) {
          final rawTransactions = (t as List).cast<Map<String, dynamic>>();
          final transactions = [
            for (final t in rawTransactions) Transaction.fromJson(t)
          ];
          final filtered = _getTransactionFilter(bankAccount, () {
            final max = transactions
                .map((t) => t.amount)
                .reduce((a, b) => a > b ? a : b);
            return TransactionFilter(count: 10, max: max);
          })()
              .filter(transactions)
              .toList();

          return filtered;
        }
        throw ArgumentError('No transactions found for $bankAccount');
      }),
    );
  }

  @override
  void setTransactionFilter(
      {required String bankAccount, required TransactionFilter filter}) {
    _getTransactionFilter(bankAccount).value = filter;
  }

  Signal<TransactionFilter> _getTransactionFilter(String bankAccount,
      [TransactionFilter Function()? filterCreator]) {
    return _filterMap.putIfAbsent(bankAccount, () {
      assert(filterCreator != null);
      return signal(filterCreator!());
    });
  }

  @override
  TransactionFilter getTransactionFilter(String bankAccount) {
    return untracked(() => _getTransactionFilter(bankAccount).value);
  }
}
