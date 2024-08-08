import 'dart:convert';
import 'dart:io';

import 'package:finurja_assignment/models/bank_account.dart';
import 'package:finurja_assignment/models/transaction.dart';
import 'package:finurja_assignment/providers/data.dart';
import 'package:signals/signals.dart';

class JsonDataProvider implements DataProvider {
  final String _jsonPath;
  final Map<String, SetSignal<TransactionFilter>> _filterMap = {};

  JsonDataProvider(this._jsonPath);

  late final FutureSignal<Map<String, dynamic>> _rawData = futureSignal(
    () async {
      final file = File(_jsonPath);
      return jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    },
  );

  @override
  FutureSignal<double> get aggregateBalance => futureSignal(
        () async {
          final data = await _rawData.future;
          return data['aggregateBalance'] as double;
        },
      );

  @override
  FutureSignal<Map<String, BankAccount>> get bankAccounts => futureSignal(
        () async {
          final data = await _rawData.future;
          final accounts = (data['bankAccounts'] as List<dynamic>)
              .cast<Map<String, dynamic>>();

          return {
            for (final acc in accounts)
              acc['accountNo'] as String: _createAccountWithTransactionFilters(
                acc,
                _getTransactionFilter(acc['accountNo'] as String),
              )
          };
        },
      );

  @override
  void setTransactionFilter(
      {required String bankAccount, required Set<TransactionFilter> filters}) {
    _getTransactionFilter(bankAccount).value = filters;
  }

  SetSignal<TransactionFilter> _getTransactionFilter(String bankAccount) {
    return _filterMap.putIfAbsent(
        bankAccount,
        () => <TransactionFilter>{
              CountFilter(10),
            }.toSignal());
  }
}

BankAccount _createAccountWithTransactionFilters(
    Map<String, dynamic> data, Set<TransactionFilter> filters) {
  final base = BankAccount.fromJson(data);
  return base.copyWith(
    transactions: _filterTransactions(base.transactions, filters),
  );
}

List<Transaction> _filterTransactions(
    List<Transaction> transactions, Set<TransactionFilter> filters) {
  Iterable<Transaction> iter = transactions;
  for (final filter in filters) {
    iter = filter.execute(iter);
  }
  return iter.toList();
}
