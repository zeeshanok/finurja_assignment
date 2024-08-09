import 'package:finurja_assignment/models/bank_account.dart';
import 'package:finurja_assignment/models/transaction.dart';
import 'package:signals/signals.dart';

abstract class DataProvider {
  FutureSignal<Map<String, BankAccount>> get bankAccounts;
  FutureSignal<double> get aggregateBalance;

  ReadonlySignal<List<Transaction>> getTransactions(String bankAccount);

  TransactionFilter getTransactionFilter(String bankAccount);

  void setTransactionFilter({
    required String bankAccount,
    required TransactionFilter filter,
  });
}

class TransactionFilter {
  final int count;
  final TransactionType? type;
  final double min, max, absoluteMax;
  final Duration? duration;

  TransactionFilter({
    required this.count,
    this.duration,
    this.type,
    this.min = 0,
    required this.max,
    double? absoluteMax,
  }) : absoluteMax = absoluteMax ?? max;

  Iterable<Transaction> filter(Iterable<Transaction> transactions) {
    var iter = transactions
        .take(count)
        .where((ts) => min <= ts.amount && ts.amount <= max);

    if (type != null) iter = iter.where((ts) => ts.type == type);
    if (duration != null) {
      iter = iter
          .where((ts) => DateTime.now().difference(ts.createdAt) <= duration!);
    }

    return iter;
  }
}

// class CountFilter extends TransactionFilter {
//   final int count;

//   CountFilter(this.count) : assert(count > 0);

//   @override
//   Iterable<Transaction> execute(Iterable<Transaction> iter) {
//     return iter.take(count);
//   }

//   @override
//   int get hashCode => 1;

//   @override
//   bool operator ==(covariant CountFilter other) {
//     return count == other.count;
//   }
// }

// class TypeFilter extends TransactionFilter {
//   final TransactionType type;

//   TypeFilter(this.type);

//   @override
//   Iterable<Transaction> execute(Iterable<Transaction> iter) {
//     return iter.where((element) => element.type == type);
//   }

//   @override
//   int get hashCode => 2;

//   @override
//   bool operator ==(covariant TypeFilter other) {
//     return type == other.type;
//   }
// }

// class RangeFilter extends TransactionFilter {
//   final double min;
//   final double max;

//   RangeFilter(this.min, this.max) : assert(min < max);

//   @override
//   Iterable<Transaction> execute(Iterable<Transaction> iter) {
//     return iter
//         .where((element) => element.amount >= min && element.amount <= max);
//   }

//   @override
//   int get hashCode => 3;

//   @override
//   bool operator ==(covariant RangeFilter other) {
//     return min == other.min && max == other.max;
//   }
// }
