// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required TransactionType type,
    required double amount,
    required String transactionNo,
    @JsonKey(fromJson: _dateTimeFromJson) required DateTime createdAt,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}

enum TransactionType {
  credit,
  debit;

  static TransactionType fromJson(String type) {
    switch (type) {
      case 'credit':
        return TransactionType.credit;
      case 'debit':
        return TransactionType.debit;
      default:
        throw ArgumentError('Invalid transaction type: $type');
    }
  }
}

DateTime _dateTimeFromJson(int e) =>
    DateTime.fromMillisecondsSinceEpoch(e * 1000);
