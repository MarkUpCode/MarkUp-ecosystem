import 'package:intl/intl.dart';

final NumberFormat _currencyFormatter =
    NumberFormat.currency(locale: 'es_EC', name: 'USD', symbol: r'$');

final DateFormat _dateFormatter =
DateFormat('dd MMM yyyy', 'es');

final DateFormat _dateTimeFormatter =
DateFormat('dd MMM yyyy, HH:mm', 'es');

String formatCurrency(num value) {
  return _currencyFormatter.format(value);
}

String formatDate(DateTime? value) {
  if (value == null) {
    return '-';
  }

  return _dateFormatter.format(value);
}

String formatDateTime(DateTime? value) {
  if (value == null) {
    return '-';
  }

  return _dateTimeFormatter.format(value);
}
