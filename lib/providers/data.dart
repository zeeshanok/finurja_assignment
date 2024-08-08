import 'package:finurja_assignment/models/bank_account.dart';
import 'package:finurja_assignment/models/transaction.dart';
import 'package:signals/signals.dart';

abstract class DataProvider {
  FutureSignal<Map<String, BankAccount>> get bankAccounts;
  FutureSignal<double> get aggregateBalance;

  void setTransactionFilter({
    required String bankAccount,
    required Set<TransactionFilter> filters,
  });
}

sealed class TransactionFilter {
  Iterable<Transaction> execute(Iterable<Transaction> iter);
}

class CountFilter extends TransactionFilter {
  final int count;

  CountFilter(this.count) : assert(count > 0);

  @override
  Iterable<Transaction> execute(Iterable<Transaction> iter) {
    return iter.take(count);
  }
}

class TypeFilter extends TransactionFilter {
  final String type;

  TypeFilter(this.type);

  @override
  Iterable<Transaction> execute(Iterable<Transaction> iter) {
    return iter.where((element) => element.type == type);
  }
}
