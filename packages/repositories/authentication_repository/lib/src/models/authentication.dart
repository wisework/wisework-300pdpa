import 'dart:convert';

import 'package:pdpa_utils/pdpa_utils.dart';

class Authentication {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String companyId;
  final DateTimestamp loginTimestamp;
  final DateTimestamp expirationTime;

  Authentication({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.companyId,
    required this.loginTimestamp,
    required this.expirationTime,
  });

  static Authentication get initial {
    return Authentication(
      userId: '',
      firstName: '',
      lastName: '',
      email: '',
      companyId: '',
      loginTimestamp: DateTimestamp.initial,
      expirationTime: DateTimestamp.initial,
    );
  }

  Authentication copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? companyId,
    DateTimestamp? loginTimestamp,
    DateTimestamp? expirationTime,
  }) {
    return Authentication(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      companyId: companyId ?? this.companyId,
      loginTimestamp: loginTimestamp ?? this.loginTimestamp,
      expirationTime: expirationTime ?? this.expirationTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'companyId': companyId,
      'loginTimestamp': loginTimestamp.time,
      'expirationTime': expirationTime.time,
    };
  }

  factory Authentication.fromMap(Map<String, dynamic> map) {
    return Authentication(
      userId: map['userId'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      companyId: map['companyId'] as String,
      loginTimestamp: DateTimestamp(time: map['loginTimestamp']),
      expirationTime: DateTimestamp(time: map['expirationTime']),
    );
  }

  String toJson() {
    final map = <String, dynamic>{
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'companyId': companyId,
      'loginTimestamp': loginTimestamp.time.toDate().toUtc().toIso8601String(),
      'expirationTime': expirationTime.time.toDate().toUtc().toIso8601String(),
    };
    return json.encode(map);
  }

  factory Authentication.fromJson(String source) {
    final map = json.decode(source) as Map<String, dynamic>;
    return Authentication(
      userId: map['userId'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      companyId: map['companyId'] as String,
      loginTimestamp: DateTimestamp.fromDate(
        DateTime.parse(map['loginTimestamp']),
      ),
      expirationTime: DateTimestamp.fromDate(
        DateTime.parse(map['expirationTime']),
      ),
    );
  }

  @override
  String toString() {
    return 'Authentication(userId: $userId, firstName: $firstName, lastName: $lastName, email: $email, companyId: $companyId, loginTimestamp: $loginTimestamp, expirationTime: $expirationTime)';
  }
}
