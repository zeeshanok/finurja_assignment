import 'package:intl/intl.dart';

final _currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
final _dateTime = DateFormat.yMd().add_jm();

String currencyFormat(double amount) => _currency.format(amount);

String dateFormat(DateTime date) => _dateTime.format(date);
