import 'package:cloud_firestore/cloud_firestore.dart';

class DateTimestamp {
  final Timestamp time;

  DateTimestamp({
    required this.time,
  });

  static Timestamp get initial => Timestamp.fromMillisecondsSinceEpoch(0);

  static Timestamp get now => Timestamp.now();

  static DateTimestamp parse(String date) {
    return DateTimestamp(time: Timestamp.fromDate(DateTime.parse(date)));
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
