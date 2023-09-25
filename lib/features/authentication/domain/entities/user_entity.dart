import 'package:equatable/equatable.dart';

import 'package:pdpa/core/utils/constants.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.citizenId,
    required this.profileImage,
    required this.role,
    required this.companies,
    required this.currentCompany,
    required this.defaultLanguage,
    required this.isEmailVerified,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  UserEntity.empty()
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

  final String id;
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String citizenId;
  final String profileImage;
  final UserRoles role;
  final List<String> companies;
  final String currentCompany;
  final String defaultLanguage;
  final bool isEmailVerified;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

  @override
  List<Object?> get props {
    return [
      id,
      uid,
      firstName,
      lastName,
      email,
      phoneNumber,
      citizenId,
      profileImage,
      role,
      companies,
      currentCompany,
      defaultLanguage,
      isEmailVerified,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
