import 'package:intl/intl.dart';

//convert any date to any pattern and return string
String formatDate(DateTime date, String pattern) {
  return DateFormat(pattern).format(date);
}

/*
* How to use formatDate
      *** Predefined Patterns: ***
      d: Numeric day of the month, without leading zeros (1-31).
      dd: Numeric day of the month, with leading zeros (01-31).
      EEE: Abbreviated weekday name (Mon, Tue, Wed, etc.).
      EEEE: Full weekday name (Monday, Tuesday, Wednesday, etc.).
      M: Numeric month of the year, without leading zeros (1-12).
      MM: Numeric month of the year, with leading zeros (01-12).
      MMM: Abbreviated month name (Jan, Feb, Mar, etc.).
      MMMM: Full month name (January, February, March, etc.).
      y: Numeric year, without leading zeros (e.g., 2020 would be 20).
      yy: Two-digit year (e.g., 2020 would be 20).
      yyyy: Four-digit year (e.g., 2020).
      h: Hour in 1-12 format, without leading zeros.
      hh: Hour in 1-12 format, with leading zeros.
      H: Hour in 0-23 format, without leading zeros.
      HH: Hour in 0-23 format, with leading zeros.
      m: Minute, without leading zeros.
      mm: Minute, with leading zeros.
      s: Second, without leading zeros.
      ss: Second, with leading zeros.
      S: Fractional second, single digit.
      SSS: Fractional second, three digits (millisecond).
      a: AM/PM marker.
      z: Time zone name.
      Z: Time zone offset (e.g., +0200).
      *** Examples of Custom Patterns: ***
      "yyyy-MM-dd": Formats a date as 2024-03-11.
      "dd/MM/yyyy": Formats a date as 11/03/2024.
      "EEE, MMM d, ''yy": Formats a date as Mon, Mar 11, '24.
      "h:mm a": Formats a time as 5:08 PM.
      "yyyy-MM-dd HH:mm:ss": Formats a date and time as 2024-03-11 17:08:00.
      "MMMM d, yyyy 'at' h:mma": Formats a date and time as March 11, 2024 at 5:08PM.
* */
