import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdpa/core/utils/constants.dart';
import 'package:pdpa/core/utils/typedef.dart';
import 'package:pdpa/features/authentication/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.uid,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phoneNumber,
    required super.citizenId,
    required super.profileImage,
    required super.username,
    required super.password,
    required super.role,
    required super.companies,
    required super.currentCompany,
    required super.defaultLanguage,
    required super.isEmailVerified,
    required super.version,
    required super.status,
    required super.createdBy,
    required super.createdDate,
    required super.updatedBy,
    required super.updatedDate,
  });

  UserModel.empty()
      : this(
          id: '',
          uid: '',
          firstName: '',
          lastName: '',
          email: '',
          phoneNumber: '',
          citizenId: '',
          profileImage: '',
          username: '',
          password: '',
          role: '',
          companies: [],
          currentCompany: '',
          defaultLanguage: '',
          isEmailVerified: false,
          version: 1,
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: Timestamp.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: Timestamp.fromMillisecondsSinceEpoch(0),
        );

  UserModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          uid: map['uid'] as String,
          firstName: map['firstName'] as String,
          lastName: map['lastName'] as String,
          email: map['email'] as String,
          phoneNumber: map['phoneNumber'] as String,
          citizenId: map['citizenId'] as String,
          profileImage: map['profileImage'] as String,
          username: map['username'] as String,
          password: map['password'] as String,
          role: map['role'] as String,
          companies: List<dynamic>.from((map['companies'] as List<dynamic>))
              .map((item) => item.toString())
              .toList(),
          currentCompany: map['currentCompany'] as String,
          defaultLanguage: map['defaultLanguage'] as String,
          isEmailVerified: map['isEmailVerified'] as bool,
          version: map['version'] as int,
          status: ActiveStatus.values[map['status'] as int],
          createdBy: map['createdBy'] as String,
          createdDate:
              Timestamp.fromDate(DateTime.parse(map['createdDate'] as String)),
          updatedBy: map['updatedBy'] as String,
          updatedDate:
              Timestamp.fromDate(DateTime.parse(map['updatedDate'] as String)),
        );

  DataMap toMap() => {
        'id': id,
        'uid': uid,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'citizenId': citizenId,
        'profileImage': profileImage,
        'username': username,
        'password': password,
        'role': role,
        'companies': companies,
        'currentCompany': currentCompany,
        'defaultLanguage': defaultLanguage,
        'isEmailVerified': isEmailVerified,
        'version': version,
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate,
        'updatedBy': updatedBy,
        'updatedDate': updatedDate,
      };

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as DataMap);

  String toJson() => json.encode(toMap());

  UserModel copyWith({
    String? id,
    String? uid,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? citizenId,
    String? profileImage,
    String? username,
    String? password,
    String? role,
    List<String>? companies,
    String? currentCompany,
    String? defaultLanguage,
    bool? isEmailVerified,
    int? version,
    ActiveStatus? status,
    String? createdBy,
    Timestamp? createdDate,
    String? updatedBy,
    Timestamp? updatedDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      citizenId: citizenId ?? this.citizenId,
      profileImage: profileImage ?? this.profileImage,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
      companies: companies ?? this.companies,
      currentCompany: currentCompany ?? this.currentCompany,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      version: version ?? this.version,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }
}
