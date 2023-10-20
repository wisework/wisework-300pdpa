import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/etc/user_company_role.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.citizenId,
    required this.profileImage,
    required this.roles,
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

  final String id;
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String citizenId;
  final String profileImage;
  final List<UserCompanyRole> roles;
  final List<String> companies;
  final String currentCompany;
  final String defaultLanguage;
  final bool isEmailVerified;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

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
          roles: [],
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
          roles: List<UserCompanyRole>.from(
            (map['roles'] as DataMap).entries.map<UserCompanyRole>((item) =>
                UserCompanyRole.fromMap({'id': item.key, 'role': item.value})),
          ),
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
        'uid': uid,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'citizenId': citizenId,
        'profileImage': profileImage,
        'roles': roles.fold(
          {},
          (map, userCompanyRole) => map..addAll(userCompanyRole.toMap()),
        ),
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

  factory UserModel.fromDocument(FirebaseDocument document) {
    DataMap response = document.data()!;
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
    List<UserCompanyRole>? roles,
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
      roles: roles ?? this.roles,
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
      roles,
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
