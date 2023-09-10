import 'package:cloud_firestore/cloud_firestore.dart';

class DateTimestamp {
  final Timestamp time;

  DateTimestamp({
    required this.time,
  });

  static DateTimestamp get initial {
    return DateTimestamp(time: Timestamp.fromMillisecondsSinceEpoch(0));
  }

  static DateTimestamp get now => DateTimestamp(time: Timestamp.now());

  static DateTimestamp fromDate(DateTime date) {
    return DateTimestamp(time: Timestamp.fromDate(date));
  }

  DateTimestamp addDays(int days) {
    return DateTimestamp(
      time: Timestamp.fromDate(time.toDate().add(Duration(days: days))),
    );
  }

  DateTimestamp copyWith({
    Timestamp? time,
  }) {
    return DateTimestamp(
      time: time ?? this.time,
    );
  }

  @override
  String toString() => 'DateTimestamp(time: $time)';
}
