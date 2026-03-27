import 'package:intl/intl.dart';

abstract final class AppDateFormats {
  AppDateFormats._();

  static final DateFormat _date = DateFormat('dd/MM/yyyy', 'pt_BR');
  static final DateFormat _time = DateFormat('HH:mm', 'pt_BR');
  static final DateFormat _dateTime = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR');
  static String date(DateTime d) => _date.format(d);
  static String time(DateTime d) => _time.format(d);
  static String dateTime(DateTime d) => _dateTime.format(d);
  static String dateAndTimeBullet(DateTime d) => '${date(d)} · ${time(d)}';
}
