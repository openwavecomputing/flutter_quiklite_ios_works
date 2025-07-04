import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  // Singleton approach
  static final DateTimeUtils _instance = DateTimeUtils._internal();

  factory DateTimeUtils() => _instance;

  DateTimeUtils._internal();

  static String standardDateTimeFormat =
      "yyyy-MM-dd HH:mm:ss"; // 2025-05-27 17:25:00

  static String formatFromCurrentDateTimeForAPI() {
    DateTime currentDate = DateTime.now();
    String strCurrentDate =
        DateFormat(standardDateTimeFormat).format(currentDate);
    debugPrint('strCurrentDate $strCurrentDate');
    return strCurrentDate;
  }


}
