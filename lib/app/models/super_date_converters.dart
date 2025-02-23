import 'package:date_only_field/date_only_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SuperDateConverters {
  /// Specify a defaultDateTimeToMapFormat (formattedString or timestamp) default (formattedString)
  static const DateTimeToMapFormats defaultDateTimeToMapFormat = DateTimeToMapFormats.formattedString;
  static get isStr => defaultDateTimeToMapFormat == DateTimeToMapFormats.formattedString;

  /// Specify a defaultDateFormat (Optional) default (dd-MMMM-yyyy)
  static const String defaultDateFormatStr = ('dd-MM-yyyy');
  static DateFormat defaultDateFormat = DateFormat(defaultDateFormatStr);

  /// Specify a defaultTimeFormat (Optional) default (hh:mm a)
  static const String defaultTimeFormatStr = ('hh:mm a');
  static DateFormat defaultTimeFormat = DateFormat(defaultTimeFormatStr);

  /// Specify a defaultDateTimeFormat (Optional) default (dd-MMMM-yyyy - hh:mm a)
  static const String defaultDateTimeFormatStr = ('$defaultDateFormatStr - $defaultTimeFormatStr');
  static DateFormat defaultDateTimeFormat = DateFormat(defaultDateTimeFormatStr);

  static DateTime toDateTime(TimeOfDay x) {
    return DateTime(2020, 1, 1, x.hour, x.minute);
  }

  static TimeOfDay toTimeOfDay(DateTime x) {
    return TimeOfDay.fromDateTime(x);
  }

  static dynamic toMapConversion(obj, {bool isTimeStamp = false, DateFormat? specialFormat}) {
    if (isTimeStamp) {
      if (obj is Date || obj is DateTime) {
        return obj.millisecondsSinceEpoch;
      } else {
        return toDateTime(obj).millisecondsSinceEpoch;
      }
    } else if (specialFormat != null) {
      return formatObj(obj);
    } else {
      return _toMapConversion(obj);
    }
  }

  static dynamic _toMapConversion(obj) {
    if (isStr) return formatObj(obj);
    if (obj is Date || obj is DateTime) {
      return obj.millisecondsSinceEpoch;
    } else if (obj is TimeOfDay) {
      return defaultTimeFormat.format(toDateTime(obj));
    }
  }

  static String formatObj(obj, {DateFormat? specialFormat}) {
    if (obj is Date) {
      return obj.format(specialFormat?.pattern ?? defaultDateFormatStr);
    } else if (obj is DateTime) {
      return (specialFormat ?? defaultDateTimeFormat).format(obj);
    } else if (obj is TimeOfDay) {
      return (specialFormat ?? defaultTimeFormat).format(toDateTime(obj));
    }
    return obj.toString();
  }

  static DateTime? tryParseDateTime(String x, {bool isUtc = false}) {
    try {
      if (int.tryParse(x) != null) {
        return DateTime.fromMillisecondsSinceEpoch(int.parse(x), isUtc: isUtc);
      } else if (DateTime.tryParse(x) != null) {
        return DateTime.parse(x);
      } else {
        return defaultDateTimeFormat.parse(x);
      }
    } catch (e) {
      return null;
    }
  }

  static Date? tryParseDate(String x, {bool isUtc = false}) {
    try {
      var r = tryParseDateTime(x, isUtc: isUtc);
      if (r != null) {
        return Date.fromDateTime(r);
      } else {
        return Date.parse(x, dateFormat: defaultDateFormatStr);
      }
    } catch (e) {
      return null;
    }
  }

  static TimeOfDay? tryParseTime(String x) {
    DateTime? d;
    try {
      d = defaultTimeFormat.parse(x);
    } catch (e) {
      d = tryParseDateTime(x);
    }
    return d == null ? null : TimeOfDay.fromDateTime(d);
  }
}

enum DateTimeToMapFormats { formattedString, timestamp }

extension TimeOfDayExtensions on TimeOfDay {
  bool get isFuture => isAfter(TimeOfDay.now());

  /// is before now
  bool get isPast => isBefore(TimeOfDay.now());

  bool equal(TimeOfDay other) {
    return hour == other.hour && minute == other.minute;
  }

  bool isEqualOrBefore(TimeOfDay other) {
    if (hour < other.hour) {
      return true;
    } else if (hour == other.hour) {
      return (minute <= other.minute);
    }
    return false;
  }

  bool isBefore(TimeOfDay other) {
    if (hour < other.hour) {
      return true;
    } else if (hour == other.hour) {
      return (minute < other.minute);
    }
    return false;
  }

  bool isAfter(TimeOfDay other) {
    if (hour > other.hour) {
      return true;
    } else if (hour == other.hour) {
      return (minute > other.minute);
    }
    return false;
  }

  bool isEqualOrAfter(TimeOfDay other) {
    if (hour > other.hour) {
      return true;
    } else if (hour == other.hour) {
      return (minute >= other.minute);
    }
    return false;
  }

  bool operator <(TimeOfDay other) => isBefore(other);
  bool operator <=(TimeOfDay other) => isEqualOrBefore(other);
  bool operator >(TimeOfDay other) => isAfter(other);
  bool operator >=(TimeOfDay other) => isEqualOrAfter(other);
}

extension DateTimeExtensions on DateTime {
  bool get isFuture => isAfter(DateTime.now());

  /// is before now
  bool get isPast => isBefore(DateTime.now());

  TimeOfDay get extractTime => TimeOfDay.fromDateTime(this);

  bool equal(DateTime other) {
    return year == other.year && month == other.month && day == other.day && hour == other.hour && minute == other.minute && second == other.second;
  }

  bool equalDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isEqualOrBefore(DateTime other) {
    if (year < other.year) {
      return true;
    } else if (year == other.year) {
      if (month < other.month) {
        return true;
      } else if (month == other.month) {
        if (day < other.day) {
          return true;
        } else if (day == other.day) {
          if (hour < other.hour) {
            return true;
          } else if (hour == other.hour) {
            if (minute < other.minute) {
              return true;
            } else if (minute == other.minute) {
              return (second <= other.second);
            }
          }
        }
      }
    }

    return false;
  }

  bool isBefore(DateTime other) {
    if (year < other.year) {
      return true;
    } else if (year == other.year) {
      if (month < other.month) {
        return true;
      } else if (month == other.month) {
        if (day < other.day) {
          return true;
        } else if (day == other.day) {
          if (hour < other.hour) {
            return true;
          } else if (hour == other.hour) {
            if (minute < other.minute) {
              return true;
            } else if (minute == other.minute) {
              return (second < other.second);
            }
          }
        }
      }
    }
    return false;
  }

  bool isAfter(DateTime other) {
    if (year > other.year) {
      return true;
    } else if (year == other.year) {
      if (month > other.month) {
        return true;
      } else if (month == other.month) {
        if (day > other.day) {
          return true;
        } else if (day == other.day) {
          if (hour > other.hour) {
            return true;
          } else if (hour == other.hour) {
            if (minute > other.minute) {
              return true;
            } else if (minute == other.minute) {
              return (second > other.second);
            }
          }
        }
      }
    }
    return false;
  }

  bool isEqualOrAfter(DateTime other) {
    if (year > other.year) {
      return true;
    } else if (year == other.year) {
      if (month > other.month) {
        return true;
      } else if (month == other.month) {
        if (day > other.day) {
          return true;
        } else if (day == other.day) {
          if (hour > other.hour) {
            return true;
          } else if (hour == other.hour) {
            if (minute > other.minute) {
              return true;
            } else if (minute == other.minute) {
              return (second >= other.second);
            }
          }
        }
      }
    }
    return false;
  }

  bool operator <(DateTime other) => isBefore(other);
  bool operator <=(DateTime other) => isEqualOrBefore(other);
  bool operator >(DateTime other) => isAfter(other);
  bool operator >=(DateTime other) => isEqualOrAfter(other);
}
