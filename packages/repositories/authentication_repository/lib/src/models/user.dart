import 'package:pdpa_utils/pdpa_utils.dart';

class User {
  final String id;
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String citizenId;
  final String profileImage;
  final String username;
  final String password;
  final String role;
  final List<String> companies;
  final String currentCompany;
  final String defaultLanguage;
  final bool isEmailVerified;
  final int version;
  final ActiveStatus status;
  final String createdBy;
  final DateTimestamp createdDate;
  final String updatedBy;
  final DateTimestamp updatedDate;

  User({
    required this.id,
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.citizenId,
    required this.profileImage,
    required this.username,
    required this.password,
    required this.role,
    required this.companies,
    required this.currentCompany,
    required this.defaultLanguage,
    required this.isEmailVerified,
    required this.version,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  static User get initial {
    return User(
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
      defaultLanguage: 'en-US',
      isEmailVerified: false,
      version: 1,
      status: ActiveStatus.active,
      createdBy: '',
      createdDate: DateTimestamp.initial,
      updatedBy: '',
      updatedDate: DateTimestamp.initial,
    );
  }

  User copyWith({
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
    DateTimestamp? createdDate,
    String? updatedBy,
    DateTimestamp? updatedDate,
  }) {
    return User(
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
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
      'createdDate': createdDate.time,
      'updatedBy': updatedBy,
      'updatedDate': updatedDate.time,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
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
      companies: List<String>.from((map['companies'] as List<String>)),
      currentCompany: map['currentCompany'] as String,
      defaultLanguage: map['defaultLanguage'] as String,
      isEmailVerified: map['isEmailVerified'] as bool,
      version: map['version'] as int,
      status: ActiveStatus.values[map['status'] as int],
      createdBy: map['createdBy'] as String,
      createdDate: DateTimestamp(time: map['createdDate']),
      updatedBy: map['updatedBy'] as String,
      updatedDate: DateTimestamp(time: map['updatedDate']),
    );
  }

  @override
  String toString() {
    return 'User(id: $id, uid: $uid, firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, citizenId: $citizenId, profileImage: $profileImage, username: $username, password: $password, role: $role, companies: $companies, currentCompany: $currentCompany, defaultLanguage: $defaultLanguage, isEmailVerified: $isEmailVerified, version: $version, status: $status, createdBy: $createdBy, createdDate: $createdDate, updatedBy: $updatedBy, updatedDate: $updatedDate)';
  }
}
