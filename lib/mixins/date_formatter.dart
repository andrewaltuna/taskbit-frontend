import 'package:intl/intl.dart';

class DateFormatter {
  String formatDate(DateTime date) {
    DateFormat dateFormat = DateFormat('MM/dd/yyyy');
    return dateFormat.format(date);
  }
}
