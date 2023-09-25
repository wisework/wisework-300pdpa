import 'dart:convert';

import 'package:pdpa/core/utils/constants.dart';
import 'package:pdpa/core/utils/typedef.dart';
import 'package:pdpa/features/authentication/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.uid,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phoneNumber,
    required super.citizenId,
    required super.profileImage,
    required super.role,
    required super.companies,
    required super.currentCompany,
    required super.defaultLanguage,
    required super.isEmailVerified,
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
          role: UserRoles.viewer,
          companies: [],
          currentCompany: '',
          defaultLanguage: '',
          isEmailVerified: false,
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
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
          role: UserRoles.values[map['role'] as int],
          companies: List<dynamic>.from((map['companies'] as List<dynamic>))
              .map((item) => item.toString())
              .toList(),
          currentCompany: map['currentCompany'] as String,
          defaultLanguage: map['defaultLanguage'] as String,
          isEmailVerified: map['isEmailVerified'] as bool,
          status: ActiveStatus.values[map['status'] as int],
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
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
        'role': role.index,
        'companies': companies,
        'currentCompany': currentCompany,
        'defaultLanguage': defaultLanguage,
        'isEmailVerified': isEmailVerified,
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as DataMap);

  String toJson() => json.encode(toMap());

  factory UserModel.fromDocument(FirebaseDocument document) {
    Map<String, dynamic> response = document.data()!;
    response['id'] = document.id;
    return UserModel.fromMap(response);
  }

  UserModel copyWith({
    String? id,
    String? uid,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? citizenId,
    String? profileImage,
    UserRoles? role,
    List<String>? companies,
    String? currentCompany,
    String? defaultLanguage,
    bool? isEmailVerified,
    ActiveStatus? status,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
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
      role: role ?? this.role,
      companies: companies ?? this.companies,
      currentCompany: currentCompany ?? this.currentCompany,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }
}
