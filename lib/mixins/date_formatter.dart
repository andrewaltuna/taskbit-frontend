import 'package:intl/intl.dart';

class DateFormatter {
  String formatDate(DateTime? date) {
    if (date != null) {
      DateFormat dateFormat = DateFormat('MM/dd/yyyy');
      return dateFormat.format(date);
    }
    return '';
  }
}
